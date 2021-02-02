//  SystemConfigurationEditorListView.swift
//  HomeBridge
//
//  Created by colin on 17/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import SwiftUI

struct SystemConfigurationEditorListView: View {
    @ObservedObject var config: ConfigurationProvider
    @Binding var joinedParties: String
    
    static let firstColumn: CGFloat = 0.4
    let leadingColumn: CGFloat = firstColumn
    let trailingColumn: CGFloat = 1 - firstColumn
    let controlPadding: CGFloat = 20
    let centreSpace: CGFloat = 10
    let formWidth: CGFloat  = 400
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            HStack(alignment: .center, spacing: self.centreSpace) {
                Text("Plan ID:")
                    .frame(width: self.formWidth * self.leadingColumn, alignment: .trailing)
                TextField("", text: self.$config.planID)
                    .frame(width: self.formWidth * self.trailingColumn, alignment: .leading)
            }
            
            HStack(alignment: .center, spacing: self.centreSpace) {
                Text("Automation Address:")
                    .frame(width: self.formWidth * self.leadingColumn, alignment: .trailing)
                TextField("", text: self.$config.automationAddress)
                    .frame(width: self.formWidth * self.trailingColumn, alignment: .leading)
            }
            
            HStack(alignment: .center, spacing: self.centreSpace) {
                Text("Relay message address:")
                    .frame(width: self.formWidth * self.leadingColumn, alignment: .trailing)
                TextField("", text: self.$config.relayMessageAddress)
                    .frame(width: self.formWidth * self.trailingColumn, alignment: .leading)
            }

            HStack(alignment: .center, spacing: self.centreSpace) {
                Text("Use messaging:")
                    .frame(width: self.formWidth * self.leadingColumn, alignment: .trailing)
                Toggle("", isOn: self.$config.useRelayMessaging)
                    .toggleStyle(NeuToggleStyle())
                    .frame(width: self.formWidth * self.trailingColumn, alignment: .leading)
            }

            HStack(alignment: .center, spacing: self.centreSpace) {
                Text("Telemetry host:")
                    .frame(width: self.formWidth * self.leadingColumn, alignment: .trailing)
                TextField("", text: self.$config.telemetryHost)
                    .frame(width: self.formWidth * self.trailingColumn, alignment: .leading)
            }
            
            HStack(alignment: .center, spacing: self.centreSpace) {
                Text("Telemetry topic:")
                    .frame(width: self.formWidth * self.leadingColumn, alignment: .trailing)
                TextField("", text: self.$config.telemetryTopic)
                    .frame(width: self.formWidth * self.trailingColumn, alignment: .leading)
            }
            
//            HStack(alignment: .center, spacing: self.centreSpace) {
//                Text("Setup code:")
//                    .frame(width: self.formWidth * self.leadingColumn, alignment: .trailing)
//                TextField("", text: self.$config.setupCode)
//                    .frame(width: self.formWidth * self.trailingColumn, alignment: .leading)
//            }
            
            HStack(alignment: .center, spacing: self.centreSpace) {
                Text("Session timeout:")
                    .frame(width: self.formWidth * self.leadingColumn, alignment: .trailing)
                HStack {
                    Slider(value: self.$config.sessionTimeout, in: 20...120, step: 10)
                    
                    Text("\(self.config.sessionTimeout, specifier: "%.0f") (secs)")
                        .frame(width: 60,  alignment: .trailing)
                }
                .frame(width: self.formWidth * self.trailingColumn, alignment: .leading)
            }
            
            HStack(alignment: .center, spacing: self.centreSpace) {
                Text("Charting report size:")
                    .frame(width: self.formWidth * self.leadingColumn, alignment: .trailing)
                HStack {
                    Slider(value: self.$config.reportSize, in: 5...30, step: 5)
                    
                    Text("\(self.config.reportSize, specifier: "%.0f") (mins)")
                        .frame(width: 60,  alignment: .trailing)
                }
                .frame(width: self.formWidth * self.trailingColumn, alignment: .leading)
            }
            
            HStack(alignment: .top, spacing: self.centreSpace) {
                Text("Interested parties:")
                    .frame(width: self.formWidth * self.leadingColumn, alignment: .trailing)
                TextField("", text: self.$joinedParties)
                    .frame(width: self.formWidth * self.trailingColumn, alignment: .leading)
            }
        }
        .padding()
    }
}
