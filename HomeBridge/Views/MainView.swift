//  MainView.swift
//  HomeBridge
//
//  Created by colin on 23/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct MainView: View {
    @EnvironmentObject var selected: NavigationItem
    @ObservedObject var provider = deviceProvider
    @ObservedObject var config = configProvider
        
    var body: some View {
        ZStack {
            Color.neuThemeBackground.edgesIgnoringSafeArea(.all)
            HStack {
                VStack {
                    AccessoryRowView(devices: provider.devices)
                    DeviceDetailView(device: $selected.device)
                    Spacer()
                }
                
                ServiceControlView()
            }
        }
        .frame(minWidth: 600, minHeight: 750)
        .foregroundColor(.neuThemeText)
        .onAppear() {
            advertisingCoordinator.startListening()
            estateManager.compose(selected: self.selected)
        }
        .sheet(isPresented: $selected.showingActionSheet, onDismiss: nil) {
            self.selected.actionSheet
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
