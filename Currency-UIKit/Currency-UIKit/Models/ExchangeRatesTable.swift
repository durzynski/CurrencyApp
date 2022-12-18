//
//  ExchangeRatesTable.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 15/11/2022.
//

import Foundation

struct ExchangeRatesTable: Decodable {
    let table: String
    let no: String
    let effectiveDate: String
    let rates: [Rate]
}

struct Rate: Decodable {
    let currency: String
    let code: String
    let mid: Double
}
