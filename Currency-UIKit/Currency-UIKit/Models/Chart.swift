//
//  ChartModel.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 28/11/2022.
//

import Foundation

struct Chart: Codable {
    
    let rates: [ChartData]
    
}

struct ChartData: Codable {
    
    let effectiveDate: String
    let mid: Double
    
}
