//  LineView.swift
//  HomeBridge
//
//  Created by colin on 06/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

public struct LineView: View {
    @ObservedObject var data: ChartData
    @Binding var touchLocation: CGPoint
    @Binding var showIndicator: Bool
    
    @State private var showFull: Bool = false
    @State private var showBackground: Bool = true
    
    var index: Int = 0
    
    func stepWidth(_ frame: CGRect) -> CGFloat {
        if data.points.count < 2 {
            return 0
        }
        
        return frame.size.width / CGFloat(data.points.count - 1)
    }
    
    func stepHeight(_ frame: CGRect) -> CGFloat {
        var min: Double?
        var max: Double?
        let points = self.data.points
        
        if let minPoint = points.min(),
            let maxPoint = points.max(),
            minPoint != maxPoint {
                min = minPoint
                max = maxPoint
        } else {
            return 0
        }
        
        if let min = min, let max = max, min != max {
            if (min <= 0) {
                return (frame.size.height - 3) / CGFloat(max - min)
            } else {
                return (frame.size.height - 3) / CGFloat(max + min)
            }
        }
        
        return 0
    }
    
    func path(_ frame: CGRect) -> Path {
        let points = self.data.points
        return Path.quadCurvedPathWithPoints(points: points,
                                             step: CGPoint(x: stepWidth(frame),
                                                           y: stepHeight(frame)))
    }
    
    func closedPath(_ frame: CGRect) -> Path {
        let points = self.data.points
        return Path.quadClosedCurvedPathWithPoints(points: points,
                                                   step: CGPoint(x: stepWidth(frame),
                                                                 y: stepHeight(frame)))
    }
    
    public var body: some View {
        
        GeometryReader { geo in
            ZStack {
                if(self.showFull && self.showBackground) {
                    
                    self.closedPath(geo.frame(in: .local))
                        .fill(Color.chartBackground)
                        .rotationEffect(.degrees(180), anchor: .center)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .transition(.opacity)
                }
                
                self.path(geo.frame(in: .local))
                    .trim(from: 0, to: self.showFull ? 1:0)
                    .stroke(Color.chartLine, lineWidth: 3)
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .animation(Animation.easeOut(duration: 1.2).delay(Double(self.index)*0.4))
                    .onAppear { self.showFull = true }
                    .onDisappear { self.showFull = false }
                    .drawingGroup()
                
                if(self.showIndicator) {
                    
                    IndicatorKnobView()
                        .position(self.getClosestPointOnPath(geo.frame(in: .local),
                                                             touchLocation: self.touchLocation))
                        .rotationEffect(.degrees(180), anchor: .center)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
            }
        }
    }
    
    func getClosestPointOnPath(_ frame: CGRect, touchLocation: CGPoint) -> CGPoint {
        let closest = self.path(frame).point(to: touchLocation.x)
        return closest
    }
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
        
        GeometryReader{ geometry in
            LineView(data: ChartData(points: [12,230,10,54,89,12,45,27,75]),
                     touchLocation: .constant(CGPoint(x: 100, y: 12)),
                     showIndicator: .constant(true))
        }
        .frame(width: 150, height: 300)
    }
}
