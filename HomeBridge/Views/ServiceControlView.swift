//  ServiceControlView.swift
//  HomeBridge
//
//  Created by colin on 23/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct ServiceControlView: View {
    @ObservedObject var provider = deviceProvider
    @ObservedObject var advertiser = advertisingService
    @ObservedObject var manager = estateManager
    @EnvironmentObject var selected: NavigationItem

    var body: some View {
        ZStack {
            Color.neuThemeBackground.edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .fill(Color.neuThemeBackground)
                .neuOuterShadow(offset: 10, radius: 15)
                .padding(.top, -10)
            
            VStack(alignment:.center) {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.neuThemeBackground)
                        .neuOuterShadow(offset: 10, radius: 15)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.neuThemeMidlight)
                        .padding(6)
                    
                    VStack(alignment: .leading) {
                        
                        Text("Estate:")
                            .padding(.leading, 10)
                            .padding(.top, 10)
                        
                        HStack(alignment: .center) {
                            Image(manager.bridgeIsPairedImage)
                                .resizable()
                                .scaledToFit()
                            
                            Image(manager.bridgeIsSynchronisedImage)
                                .resizable()
                                .scaledToFit()
                            
                            Image(manager.bridgeIsTransmittingImage)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        Spacer()
                    }
                }
                .frame(width: 200, height: 90, alignment: .center)
                .padding(.bottom, 8)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.neuThemeBackground)
                        .neuOuterShadow(offset: 10, radius: 15)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.neuThemeMidlight)
                        .padding(6)
                    
                    LineChartView(
                        theData: manager.bridgeHits,
                        theTitle: "HAP Controller",
                        theRadius: 8)
                        .frame(width: 187, height: 187, alignment: .center)
                    
                    if advertisingService.isRunning && !manager.receivingHomekit {
                        Image("estateAttentionNeeded")
                            .resizable()
                            .opacity(0.8)
                            .frame(width: 70, height: 70)
                            .padding(.top, 95)
                            .padding(.leading, 105)
                    }
                }
                .frame(width: 200, height: 200, alignment: .center)
                .padding(.bottom, 8)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.neuThemeBackground)
                        .neuOuterShadow(offset: 10, radius: 15)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.neuThemeMidlight)
                        .padding(6)
                    
                    LineChartView(
                        theData: manager.telemetryHits,
                        theTitle: "Automation Host",
                        theRadius: 8)
                        .frame(width: 187, height: 187, alignment: .center)
                    
                    if telemetryCoordinator.isRunning && !manager.receivingTelemetry {
                        Image("estateAttentionNeeded")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.8)
                            .frame(width: 70, height: 70)
                            .padding(.top, 95)
                            .padding(.leading, 105)
                    }
                }
                .frame(width: 200, height: 200, alignment: .center)
                .padding(.bottom, 8)
                
                VStack(alignment: .leading) {
                    Text("Device Allocations:")
                        .padding(.leading, 10)
                    
                    HStack {
                        Button("Load", action: reload)
                            .neuButtonStyle(RoundedRectangle(cornerRadius: 10), theBackgroundColor: .primaryAccentColor)
                            .frame(width: 80, height: 40, alignment: .center)
                            .padding(.bottom, 8)
                            .padding(.leading, 8)
                        
                        Button("Publish", action: publish)
                            .neuButtonStyle(RoundedRectangle(cornerRadius: 10), theBackgroundColor: .secondaryAccentColor)
                            .frame(width: 80, height: 40, alignment: .center)
                            .padding(.bottom, 8)
                            .padding(.leading, 8)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Telemetry and Advertising:")
                        .padding(.leading, 10)
                    
                    HStack {
                        Button("Start", action: manager.start)
                            .neuButtonStyle(RoundedRectangle(cornerRadius: 10), theBackgroundColor: .secondaryAccentColor)
                            .disabled(!deviceProvider.isPublished || advertiser.isRunning)
                            .frame(width: 80, height: 40, alignment: .center)
                            .padding(.bottom, 8)
                            .padding(.leading, 8)
                        
                        Button("Stop", action: manager.stop)
                            .neuButtonStyle(RoundedRectangle(cornerRadius: 10))
                            .disabled(!advertiser.isRunning)
                            .frame(width: 80, height: 40, alignment: .center)
                            .padding(.bottom, 8)
                            .padding(.leading, 8)
                    }
                }
                .padding(.bottom, 8)
            }
        }
        .frame(width: 250, alignment: .center)
        .padding(.top, 8)
    }
    
    func reload() {
        deviceProvider.loadFile()
        self.selected.device = ManageableDevice()
    }

    func publish() {
        deviceProvider.publish()
        self.selected.device = ManageableDevice()
    }
}

struct ServiceControlView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceControlView()
    }
}
