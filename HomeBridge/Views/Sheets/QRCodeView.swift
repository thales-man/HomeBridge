//  QRCodeView.swift
//  HomeBridge
//
//  Created by colin on 18/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct QRCodeView: View {
    @ObservedObject var selected: NavigationItem
    @State var qrCode: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.neuThemeBackground)
                .neuOuterShadow(offset: 10, radius: 15)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.neuThemeMidlight)
                .padding(6)
            
            VStack(alignment: .leading, spacing: 5) {
                ZStack() {
                    Text(qrCode)
                        .multilineTextAlignment(.leading)
                        .font(.system(.caption, design: .monospaced))
                        .lineSpacing(-20)
                        .flexibleFrame(direction: .bothWays)
                        .background(Color.white)
                }
                .background(Color.white)
                .padding(10)
                
                HStack() {
                    Spacer()
                    
                    Button("Finished", action: self.close)
                        .neuButtonStyle(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 80, height: 40)
                }
                .padding()
            }
            .padding()
        }
    }
    
    func close() {
        self.selected.hideActionSheet()
    }
}
