//  DeviceDetailView.swift
//  HomeBridge
//
//  Created by colin on 23/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct DeviceDetailView: View {
    @Binding var device: ManageableDevice

    static let firstColumn: CGFloat = 0.4
    let leadingColumn: CGFloat = firstColumn
    let trailingColumn: CGFloat = 1 - firstColumn
    let controlPadding: CGFloat = 20
    let centreSpace: CGFloat = 10
    
    var body: some View {
        GeometryReader { geometry in
            
            if (self.device.name != "") {
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    HStack(alignment: .top, spacing: self.centreSpace) {
                        Text("Name:")
                            .frame(width: geometry.size.width * self.leadingColumn,
                                   alignment: .trailing)
                        Text(self.device.name)
                            .frame(width: (geometry.size.width * self.trailingColumn) - self.controlPadding,
                                   alignment: .leading)
                    }
                    
                    HStack(alignment: .top, spacing: self.centreSpace) {
                        Text("Accessory ID:")
                            .frame(width: geometry.size.width * self.leadingColumn,
                                   alignment: .trailing)
                        Text(self.device.accessoryId)
                            .frame(width: geometry.size.width * self.trailingColumn,
                                   alignment: .leading)
                    }
                    
                    HStack(alignment: .top, spacing: self.centreSpace) {
                        Text("Type:")
                            .frame(width: geometry.size.width * self.leadingColumn,
                                   alignment: .trailing)
                        Text(self.device.type)
                            .frame(width: geometry.size.width * self.trailingColumn,
                                   alignment: .leading)
                    }
                    
                    HStack(alignment: .top, spacing: self.centreSpace) {
                        Text("Sub Type:")
                            .frame(width: geometry.size.width * self.leadingColumn,
                                   alignment: .trailing)
                        Text(self.device.subType)
                            .frame(width: geometry.size.width * self.trailingColumn,
                                   alignment: .leading)
                    }
                    
                    HStack(alignment: .top, spacing: self.centreSpace) {
                        Text("Data:")
                            .frame(width: geometry.size.width * self.leadingColumn,
                                   alignment: .trailing)
                        Text(self.device.data)
                            .frame(width: geometry.size.width * self.trailingColumn,
                                   alignment: .leading)
                    }
                    
                    HStack(alignment: .top, spacing: self.centreSpace) {
                        Text("Last updated:")
                            .frame(width: geometry.size.width * self.leadingColumn,
                                   alignment: .trailing)
                        Text(self.device.lastUpdated)
                            .frame(width: geometry.size.width * self.trailingColumn,
                                   alignment: .leading)
                    }
                    
                    HStack(alignment: .top, spacing: self.centreSpace) {
                        Text("Advertise this item:")
                            .frame(width: geometry.size.width * self.leadingColumn,
                                   alignment: .trailing)
                        Toggle("", isOn: self.$device.isAdvertised)
                            .toggleStyle(NeuToggleStyle())
                            .frame(width: geometry.size.width * self.trailingColumn,
                                   alignment: .leading)
                    }
                    
                    HStack(alignment: .top, spacing: self.centreSpace) {
                        Text("Advertise As:")
                            .frame(width: geometry.size.width * self.leadingColumn,
                                   alignment: .trailing)
                        
                        Picker("", selection: self.$device.advertisedType) {
                            ForEach(AdvertisedType.allCases) { theType in
                                Text(theType.name)
                            }
                        }
                        .frame(width: min((geometry.size.width * self.trailingColumn) - self.controlPadding, 200),
                               alignment: .leading)
                        .padding(.leading, -10)
                    }
                    
                    if(self.device.batteryLevel != 255) {
                        
                        HStack(alignment: .top, spacing: self.centreSpace) {
                            Text("Battery Level:")
                                .frame(width: geometry.size.width * self.leadingColumn,
                                       alignment: .trailing)
                            
                            BatteryLevelView(batteryLevel: self.device.batteryLevel, controlDiameter: 100)
                                .frame(width: geometry.size.width * self.trailingColumn,
                                       alignment: .leading)
                                .padding(.top, 3)
                        }
                        
                        HStack(alignment: .top, spacing: self.centreSpace) {
                            Text("Low level warning:")
                                .frame(width: geometry.size.width * self.leadingColumn,
                                       alignment: .trailing)
                            
                            HStack {
                                Slider(value: self.$device.lowBatteryAlertLevel, in: 0...100, step: 5)
                                
                                Text("\(self.device.lowBatteryAlertLevel, specifier: "%.0f")%")
                                    .frame(width: 35,  alignment: .trailing)
                            }
                            .frame(width: min((geometry.size.width * self.trailingColumn) - self.controlPadding, 200),
                                   alignment: .leading)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
