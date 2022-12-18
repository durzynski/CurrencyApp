//
//  CurrencyChartViewModel.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 28/11/2022.
//

import Foundation

enum TopCount: Int {
    
    case last7 = 7
    case last30 = 30
    case last90 = 90
    case last180 = 180
    
}

class CurrencyChartViewModel {
    
    var table: String
    var code: String
    var dates = [String]()
    var values = [Double]()
    var count: TopCount
    
    init(table: String, code: String, dates: [String] = [String](), values: [Double] = [Double](), count: TopCount = .last7) {
        self.table = table
        self.code = code
        self.dates = dates
        self.values = values
        self.count = count
    }
    
    public func fetchChartData(completion: @escaping (Bool) -> Void) {
        
        APIManager.shared.fetchChartData(table: table, code: code, daysCount: count.rawValue) { result in
            
            switch result {
            case .success(let data):
                
                let values = data.rates.map { $0.mid }
                
                self.values = values
                
                let dates = data.rates.map { $0.effectiveDate }
                
                self.dates = dates
                
                completion(true)
                
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
}
