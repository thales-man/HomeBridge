//  EmbossedImageViewModifier.swift
//  HomeBridge
//
//  Created by colin on 09/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct EmbossedImageViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(20)
            .shadow(color: .neuThemeHighlight, radius: 2, x: -3, y: -3)
            .shadow(color: .neuThemeEmbossShadow, radius: 2, x: 3, y: 3)
    }
}
