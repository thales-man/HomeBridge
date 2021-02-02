//  ConsoleTextView.swift
//  HomeBridge
//
//  Created by colin on 25/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct ConsoleTextView: View {
    @ObservedObject var selected: NavigationItem
    @ObservedObject var console = consoleTextProvider
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.neuThemeBackground)
                .neuOuterShadow(offset: 10, radius: 15)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.neuThemeMidlight)
                .padding(6)

            VStack(alignment: .leading, spacing: 5) {
                ScrollView(.vertical) {
                    ZStack() {
                        Text(console.consoleText)
                            .flexibleFrame(direction: .bothWays)
                            .background(Color.clear)

                        Spacer()
                    }
                    .padding()
                }

                HStack() {
                    Spacer()

                    Button("Finished", action: self.close)
                        .neuButtonStyle(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 80, height: 40)
                }
                .padding()
            }
            .frame(minWidth: 500, maxWidth: 700, minHeight: 300, maxHeight: 600)
        }
        .padding()
    }
        
    func close() {
        self.selected.hideActionSheet()
    }
}
