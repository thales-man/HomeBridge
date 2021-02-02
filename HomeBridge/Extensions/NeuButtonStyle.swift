//  NavigationItem.swift
//  HomeBridge
//
//  Created by colin on 06/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

public struct NeuButtonStyle<S: Shape> : ButtonStyle {
    var shape: S
    var textColor : Color
    var shadowColor : Color
    var highlightColor : Color
    var backgroundColor : Color

    public init(_ theShape: S,
                theTextColor : Color,
                theBackground : Color,
                theShadowColor: Color,
                theHighlightColor: Color) {
        
        shape = theShape
        textColor = theTextColor
        shadowColor = theShadowColor
        highlightColor = theHighlightColor
        backgroundColor = theBackground
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            shape.fill(backgroundColor)
                .neuInnerShadow(shape, darkShadow: shadowColor, lightShadow: highlightColor, spread: 0.15, radius: 3)
                .opacity(configuration.isPressed ? 1 : 0)
                .brightness(-0.05)
                .saturation(0.01)
            
            shape.fill(backgroundColor)
                .neuOuterShadow(darkShadow: shadowColor, lightShadow: highlightColor, offset: 6, radius: 3)
                .opacity(configuration.isPressed ? 0 : 1)

            configuration.label
                .foregroundColor(textColor)
                .scaleEffect(configuration.isPressed ? 0.97 : 1)
        }
    }    
}

extension Button {
    
    public func neuButtonStyle<S : Shape>(_ theContent: S,
                                           theTextColor: Color = .neuThemeText,
                                           theBackgroundColor: Color = .neuThemeBackground,
                                           theShadowColor: Color = .neuThemeShadow,
                                           theHiglightColor: Color = .neuThemeHighlight) -> some View {

        self.buttonStyle(NeuButtonStyle(theContent,
                                         theTextColor: theTextColor,
                                         theBackground: theBackgroundColor,
                                         theShadowColor: theShadowColor,
                                         theHighlightColor: theHiglightColor))
    }
}
