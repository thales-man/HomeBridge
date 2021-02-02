//  LineChartView.swift
//  HomeBridge
//
//  Created by colin on 06/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

public struct LineChartView: View {
    @ObservedObject var data: ChartData
    
    private var title: String
    private var legend: String
    private var valueSpecifier: String
    private var radius: CGFloat
    
    @State private var touchLocation: CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    @State private var currentValue: Double = 2
    
    let hitTestWidth: CGFloat = 180
    let hitTestHeight: CGFloat = 120
    
    public init(theData: [Double],
                theTitle: String,
                theLegend: String = "",
                theRadius: CGFloat = 0,
                theSpecifier: String = "%.0f") {
        
        data = ChartData(points: theData)
        title = theTitle
        legend = theLegend
        radius = theRadius
        valueSpecifier = theSpecifier
    }
    
    public var body: some View {
        
        GeometryReader { geo in
            
            ZStack(alignment: .center) {
                
                VStack(alignment: .leading) {
                    
                    if(!self.showIndicatorDot) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(self.title)
                                .bold()
                            Text(self.legend)
                        }
                        .padding([.leading, .top])
                        
                    } else {
                        VStack(alignment: .leading) {
                            Text("\(self.currentValue, specifier: self.valueSpecifier)")
                                .font(.system(size: 30, design: .default))
                        }
                        .padding([.leading, .top])
                    }
                                        
                    LineView(data: self.data,
                             touchLocation: self.$touchLocation,
                             showIndicator: self.$showIndicatorDot)
                }
            }
        }
        .gesture(DragGesture()
            .onChanged({ value in
                self.touchLocation = value.location
                self.showIndicatorDot = true
                self.getClosestDataPoint(toPoint: value.location, width: self.hitTestWidth, height: self.hitTestHeight)
            })
            .onEnded({ value in
                self.showIndicatorDot = false
            }))
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
    
    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width: CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.points
        let stepWidth: CGFloat = width / CGFloat(points.count - 1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        let index:Int = Int(round((toPoint.x)/stepWidth))
        
        if (index >= 0 && index < points.count) {
            self.currentValue = points[index]
            return CGPoint(x: CGFloat(index) * stepWidth, y: CGFloat(points[index]) * stepHeight)
        }
        
        return .zero
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(theData: [18, 21, 49, 22, 296, 12, 37, 17, 27, 23],
                      theTitle: "A tall tail",
                      theLegend: "becomes a legend")
            .frame(width: 300, height: 200)
    }
}
