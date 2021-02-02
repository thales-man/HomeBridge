//  IndicatorKnobView.swift
//  HomeBridge
//
//  Created by colin on 06/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct IndicatorKnobView: View {
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.primaryAccentColor)
            Circle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 4))
        }
        .frame(width: 14, height: 14)
        .shadow(color: Color.neuThemeShadow, radius: 6, x: 0, y: 6)
    }
}
