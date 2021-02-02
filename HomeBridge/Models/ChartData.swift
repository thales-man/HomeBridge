//  ChartData.swift
//  Homebridge
//
//  Created by colin on 17/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

public class ChartData: ObservableObject {
    @Published var points: [Double]
    
    public init(points: [Double]) {
        self.points = points
    }
}
