//  AccessoryRowView.swift
//  HomeBridge
//
//  Created by colin on 23/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct AccessoryRowView: View {
    var devices: [ManageableDevice]

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.neuThemeBackground.edgesIgnoringSafeArea(.all)

            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(devices) { device in
                        AccessoryView(device: device)
                            .padding(.horizontal, 20)
                    }
                }
                .frame(height: 260)
                .padding(.top, 32)
                .padding(.bottom, 50)
            }
        }
    }
}
