//  NeuInnerShadowViewModifier{TShape}.swift
//  HomeBridge
//
//  Created by colin on 06/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct NeuInnerShadowViewModifier<S: Shape> : ViewModifier {
    var shape: S
    var darkShadowColor : Color = .black
    var lightShadowColor : Color = .white
    var spread: CGFloat = 0.5    //The value of spread is between 0 to 1. Higher value makes the shadow look more intense.
    var radius: CGFloat = 10
    
    init(shape: S, darkShadowColor: Color, lightShadowColor: Color, spread: CGFloat, radius:CGFloat) {
        self.shape = shape
        self.darkShadowColor = darkShadowColor
        self.lightShadowColor = lightShadowColor
        self.spread = spread
        self.radius = radius
    }

    fileprivate func strokeLineWidth(_ geo: GeometryProxy) -> CGFloat {
        return geo.size.width * 0.10
    }
    
    fileprivate func strokeLineScale(_ geo: GeometryProxy) -> CGFloat {
        let lineWidth = strokeLineWidth(geo)
        return geo.size.width / CGFloat(geo.size.width - lineWidth)
    }
    
    fileprivate func shadowOffset(_ geo: GeometryProxy) -> CGFloat {
        return geo.size.width * 0.5 * min(max(spread, 0), 1)
    }
    

    fileprivate func addSoftInnerShadow(_ content: NeuInnerShadowViewModifier.Content) -> some View {
        return GeometryReader { geo in
            
            self.shape.fill(self.lightShadowColor)
                .inverseMask(
                    self.shape
                    .offset(x: -self.shadowOffset(geo), y: -self.shadowOffset(geo))
                )
                .offset(x: self.shadowOffset(geo) , y: self.shadowOffset(geo))
                .blur(radius: self.radius)
                .shadow(color: self.lightShadowColor, radius: self.radius, x: -self.shadowOffset(geo)/2, y: -self.shadowOffset(geo)/2 )
                .mask(
                    self.shape
                )
                .overlay(
                    self.shape
                        .fill(self.darkShadowColor)
                        .inverseMask(
                            self.shape
                            .offset(x: self.shadowOffset(geo), y: self.shadowOffset(geo))
                        )
                        .offset(x: -self.shadowOffset(geo) , y: -self.shadowOffset(geo))
                        .blur(radius: self.radius)
                        .shadow(color: self.darkShadowColor, radius: self.radius, x: self.shadowOffset(geo)/2, y: self.shadowOffset(geo)/2 )
                )
                .mask(
                    self.shape
                )
        }
    }

    func body(content: Content) -> some View {
        content.overlay(
            addSoftInnerShadow(content)
        )
    }
}
