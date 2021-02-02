//  NeuOuterShadowViewModifier.swift
//  HomeBridge
//
//  Created by colin on 06/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct NeuOuterShadowViewModifier: ViewModifier {
    var lightShadowColor : Color
    var darkShadowColor : Color
    var offset: CGFloat
    var radius : CGFloat
    
    init(darkShadowColor: Color, lightShadowColor: Color, offset: CGFloat, radius: CGFloat) {
        self.darkShadowColor = darkShadowColor
        self.lightShadowColor = lightShadowColor
        self.offset = offset
        self.radius = radius
    }

    func body(content: Content) -> some View {
        content
        .shadow(color: darkShadowColor, radius: radius, x: offset, y: offset)
        .shadow(color: lightShadowColor, radius: radius, x: -offset, y: -offset)
    }

}

