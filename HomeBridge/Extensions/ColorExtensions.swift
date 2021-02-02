// ColorExtensions.swift
//  HomeBridge
//
//  Created by colin on 30/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import SwiftUI

extension Color {
    public static let primaryAccentColor = Color("primaryColor")
    public static let secondaryAccentColor = Color("secondaryColor")
    public static let statusAttentionColor =  Color("statusAttentionColor")
    public static let statusOKColor =  Color("statusOKColor")
    
    public static let neuThemeEmbossShadow = Color("neuThemeEmbossShadow")
    public static let neuThemeBackground = Color("neuThemeBackground")
    public static let neuThemeHighlight = Color("neuThemeHighlight")
    public static let neuThemeMidlight = Color("neuThemeMidlight")
    public static let neuThemeShadow = Color("neuThemeShadow")
    public static let neuThemeText = Color("neuThemeText")
    
    public static let chatLineStart = Color("chartLineStart")
    public static let chartLineEnd = Color("chartLineEnd")
    public static let chartBGStart = Color("chartBackgroundStart")
    public static let chartBGEnd = Color("chartBackgroundEnd")

    public static let chartLineGradient = Gradient(colors: [.chatLineStart, .chartLineEnd])
    public static let chartBackgroundGradient = Gradient(colors: [.chartBGStart, .chartBGEnd])

    public static let chartLine = LinearGradient(gradient: Color.chartLineGradient,
                                                 startPoint: .leading,
                                                 endPoint: .trailing)
    public static let chartBackground = LinearGradient(gradient: Color.chartBackgroundGradient,
                                                       startPoint: .top,
                                                       endPoint: .bottom)

}
