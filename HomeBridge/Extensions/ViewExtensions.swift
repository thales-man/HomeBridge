//  ViewExtensions.swift
//  HomeBridge
//
//  Created by colin on 24/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

extension View {
    
    func inverseMask<Mask>(_ mask: Mask) -> some View where Mask : View {
        self.mask(mask
            .foregroundColor(.black)
            .background(Color.white)
            .compositingGroup()
            .luminanceToAlpha()
        )
    }
    
    func embossed() -> some View {
        self.modifier(EmbossedImageViewModifier())
    }
    
    func neuInnerShadow<S : Shape>(_ content: S, darkShadow: Color = .neuThemeShadow, lightShadow: Color = .neuThemeHighlight, spread: CGFloat = 0.5, radius: CGFloat = 10) -> some View {
        modifier(
            NeuInnerShadowViewModifier(shape: content, darkShadowColor: darkShadow, lightShadowColor: lightShadow, spread: spread, radius: radius)
        )
    }
    
    func neuOuterShadow(darkShadow: Color = .neuThemeShadow, lightShadow: Color = .neuThemeHighlight, offset: CGFloat = 6, radius:CGFloat = 3) -> some View {
        modifier(NeuOuterShadowViewModifier(darkShadowColor: darkShadow, lightShadowColor: lightShadow, offset: offset, radius: radius))
    }
    
    func flexibleFrame(direction: Direction, minSize: CGFloat = 0, maxSize: CGFloat = 0, padding: CGFloat = 0) -> some View {
        
        if(direction == .bothWays) {
            return self
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(padding)
        }
        
        precondition(maxSize >= minSize, "control limits need to be properly set")
        
        if(direction == .vertical) {
            return self
                .frame(minWidth: minSize, idealWidth: minSize, maxWidth: maxSize, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(padding)
        }
        
        return self
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: minSize, maxHeight: maxSize, alignment: .topLeading)
            .padding(padding)
    }
}

enum Direction: Equatable {
    case bothWays, vertical, horizontal
}

