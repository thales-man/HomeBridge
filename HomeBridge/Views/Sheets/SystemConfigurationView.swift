//  SystemConfigurationView.swift
//  HomeBridge
//
//  Created by colin on 17/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import SwiftUI

struct SystemConfigurationView: View {
    @ObservedObject var selected: NavigationItem
    @ObservedObject var config: ConfigurationProvider
    @State var joinedParties: String = ""
    
    let centreSpace: CGFloat = 10
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.neuThemeBackground)
                .neuOuterShadow(offset: 10, radius: 15)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.neuThemeMidlight)
                .padding(6)
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text("Configuration settings...")
                    .bold()
                    .font(.headline)
                    .padding()
                
                SystemConfigurationEditorListView(config: config, joinedParties: self.$joinedParties)
                                
                HStack(alignment: .center, spacing: self.centreSpace) {
                    Spacer()
                    
                    Button("Save", action: self.save)
                        .neuButtonStyle(RoundedRectangle(cornerRadius: 10), theBackgroundColor: .secondaryAccentColor)
                        .frame(width: 80, height: 40)
                        .padding(.leading, 8)
                    
                    Button("Cancel", action: self.close)
                        .neuButtonStyle(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 80, height: 40)
                        .padding(.leading, 8)
                }
                .padding()
                
            }
            .padding()
        }
        .padding()
        .onAppear() {
            self.joinedParties = self.config.interestedParties.joined(separator: ", ")
        }
    }
    
    func save() {
        self.config.interestedParties = self.joinedParties.components(separatedBy: ", ")
        config.save()
        close()
    }
    
    func close() {
        self.selected.hideActionSheet()
    }
}
