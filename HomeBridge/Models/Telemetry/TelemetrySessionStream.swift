//  TelemetrySessionStream.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

final class TelemetrySessionStream: NSObject, StreamDelegate {
    private var currentRunLoop: RunLoop?
    private let inputStream: InputStream?
    private let outputStream: OutputStream?
    private var sessionQueue: DispatchQueue
    private var delegate: TelemetrySessionStreamDelegate

    private var inputReady = false
    private var outputReady = false
    
    init(host: String, port: UInt16, ssl: Bool, timeout: TimeInterval, delegate: TelemetrySessionStreamDelegate) {
        var inputStream: InputStream?
        var outputStream: OutputStream?
        Stream.getStreamsToHost(withName: host, port: Int(port), inputStream: &inputStream, outputStream: &outputStream)
        
        let queueLabel = host.components(separatedBy: ".").reversed().joined(separator: ".") + ".stream\(port)"
        self.sessionQueue = DispatchQueue(label: queueLabel, qos: .background, target: nil)
        self.delegate = delegate
        self.inputStream = inputStream
        self.outputStream = outputStream

        super.init()
        
        inputStream?.delegate = self
        outputStream?.delegate = self

        sessionQueue.async { [weak self] in

            guard let `self` = self else {
                return
            }

            self.currentRunLoop = RunLoop.current
            inputStream?.schedule(in: self.currentRunLoop!, forMode: RunLoop.Mode.default)
            outputStream?.schedule(in: self.currentRunLoop!, forMode: RunLoop.Mode.default)

            inputStream?.open()
            outputStream?.open()
            
            if ssl {
                let securityLevel = StreamSocketSecurityLevel.negotiatedSSL.rawValue
                inputStream?.setProperty(securityLevel, forKey: .socketSecurityLevelKey)
                outputStream?.setProperty(securityLevel, forKey: .socketSecurityLevelKey)
            }
            
            if timeout > 0 {
                DispatchQueue.global().asyncAfter(deadline: .now() +  timeout) {
                    self.connectTimeout()
                }
            }
            
            self.currentRunLoop!.run()
        }
    }
    
    deinit {
        guard let currentRunLoop = currentRunLoop else { return }
        inputStream?.close()
        inputStream?.remove(from: currentRunLoop, forMode: RunLoop.Mode.default)
        outputStream?.close()
        outputStream?.remove(from: currentRunLoop, forMode: RunLoop.Mode.default)
    }
    
    var write: StreamWriter? {
        if let outputStream = outputStream, outputReady {
            return outputStream.write
        }
        return nil
    }

    internal func connectTimeout() {
        if inputReady == false || outputReady == false {
            delegate.telemetryReady(false, in: self)
        }
    }

    @objc internal func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.openCompleted:
            let wasReady = inputReady && outputReady

            if aStream == inputStream {
                inputReady = true
            }
            else if aStream == outputStream {
                // not ready till space available
            }

            if !wasReady && inputReady && outputReady {
                delegate.telemetryReady(true, in: self)
            }
            
        case Stream.Event.hasBytesAvailable:
            if aStream == inputStream {
                delegate.telemetryReceived(in: self, inputStream!.read)
            }
            
        case Stream.Event.errorOccurred:
            delegate.telemetryErrorOccurred(in: self, error: aStream.streamError)

        case Stream.Event.endEncountered:
            if aStream.streamError != nil {
                delegate.telemetryErrorOccurred(in: self, error: aStream.streamError)
            }

        case Stream.Event.hasSpaceAvailable:
            let wasReady = inputReady && outputReady
            
            if aStream == outputStream {
                outputReady = true
            }
            
            if !wasReady && inputReady && outputReady {
                delegate.telemetryReady(true, in: self)
            }

        default:
            break
        }
    }
}
