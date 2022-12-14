//
//  ChartResponse.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 09/12/2022.
//

import Foundation

struct ChartResponse: Codable {
    
    let rates: [ChartRatesResponse]
    
}

struct ChartRatesResponse: Codable {
    
    let effectiveDate: String
    let mid: Double
    
}
