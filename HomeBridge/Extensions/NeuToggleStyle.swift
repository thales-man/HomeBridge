//  neuToggleStyle.swift
//  HomeBridge
//
//  Created by colin on 15/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct NeuToggleStyle: ToggleStyle {
    let width: CGFloat = 37
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        HStack {
            
            ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: width, height: width / 2)
                    .foregroundColor(configuration.isOn ? .primaryAccentColor : .secondaryAccentColor)
                
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: (width / 2) - 2, height: (width / 2) - 4)
                    .padding(2)
                    .foregroundColor(.white)
                    .onTapGesture {
                        withAnimation {
                            configuration.$isOn.wrappedValue.toggle()
                        }
                }
            }
            
            Spacer()
            configuration.label
        }
        .padding(.bottom, 2)
        .accessibility(activationPoint: configuration.isOn ? UnitPoint(x: 0.25, y: 0.5) : UnitPoint(x: 0.75, y: 0.5))
    }
}
