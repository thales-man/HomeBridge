//  AccessoryView.swift
//  HomeBridge
//
//  Created by colin on 23/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct AccessoryView: View {
    @ObservedObject var device: ManageableDevice
    @EnvironmentObject var selected: NavigationItem
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.neuThemeBackground)
                .neuOuterShadow()
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.neuThemeMidlight)
                .padding(6)

            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(device.confirmationState.color(), lineWidth: 6)
                .opacity(0.3)

            VStack(alignment: .center) {
                
                HStack(alignment: .top) {

                    Image(device.imageName)
                        .resizable()
                        .frame(width: 100, height: 120)
                        .embossed()
                    
                    VStack(alignment: .center, spacing: 0) {
                        
                        Spacer()

                        Button("I", action: {
                            self.device.switchState(requestedState: self.device.advertisedType.onForDevice)
                        })
                        .neuButtonStyle(Circle(), theBackgroundColor: .primaryAccentColor)
                        .frame(width: 40, height: 40, alignment: .center)
                        .padding(10)

                        Button("O", action: {
                            self.device.switchState(requestedState: self.device.advertisedType.offForDevice)
                        })
                        .neuButtonStyle(Circle())
                        .frame(width: 40, height: 40, alignment: .center)
                        .padding(10)

                        Button(action: { self.selected.device = self.device }) {
                            Image("Settings")
                                .resizable()
                                .frame(width: 25, height:  25)
                        }
                        .neuButtonStyle(Circle())
                        .frame(width: 40, height: 40, alignment: .center)
                        .padding(10)

                        Spacer()
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Text(device.name)
                        .foregroundColor(.neuThemeText)
                        .bold()
                        .padding(.leading)
                        .padding(.bottom)
                    
                    Spacer()
                }
            }
        }
    }
}
