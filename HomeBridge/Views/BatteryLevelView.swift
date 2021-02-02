//  BatteryLevelView.swift
//  HomeBridge
//
//  Created by colin on 23/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

struct BatteryLevelView: View {
    let batteryLevel: Int
    let controlDiameter: CGFloat

    var body: some View {
        let gradient = AngularGradient(gradient: Gradient(colors: [Color.red, Color.yellow, Color.green]),
                                       center: .center,
                                       angle: Angle(degrees: 0))
        
        return Circle()
            .stroke(lineWidth: 3)
            .foregroundColor(.primary)
            .background(Circle().fill(gradient).clipShape(PieChartShape(percentage: Double(self.batteryLevel))))
            .shadow(radius: 4)
            .overlay(PieChartPercentageLabel(percentage: self.batteryLevel))
            .frame(width: controlDiameter, height: controlDiameter)
        
    }
    
    struct PieChartPercentageLabel: View {
        let percentage: Int
        
        var body: some View {
            VStack {
                Text("\(self.percentage) %")
                    .font(.headline)
            }
        }
    }
    
    struct PieChartShape: Shape {
        var percentage: Double
        
        func path(in rect: CGRect) -> Path {
            var path = Path()

            let c = CGPoint(x: rect.midX, y: rect.midY)
            path.move(to: c)
            path.addArc(center: c,
                        radius: rect.width/2.0,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: (percentage/100.0) * 360), clockwise: false)
            
            path.closeSubpath()
            return path
        }
    }
}

struct BatteryLevelView_Previews: PreviewProvider {
    static var previews: some View {
        BatteryLevelView(batteryLevel: 45, controlDiameter: 100)
    }
}
