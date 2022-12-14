//
//  CurrencyChartViewModel.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 09/12/2022.
//

import Foundation

enum TopCount: Int {
    
    case last7 = 7
    case last30 = 30
    case last90 = 90
    case last180 = 180
    
}

class CurrencyChartViewModel: ObservableObject{
    
    var table: String
    var code: String

    @Published var chartData = [ChartModel]()
    @Published var isFetching = false
    @Published var count: TopCount
    
    var min: Double = 0
    var max: Double = 0
    
    init(table: String, code: String, count: TopCount = .last7) {
        self.table = table
        self.code = code
        self.count = count
    }
    
    public func fetchChartData() async throws {
        
        DispatchQueue.main.async {
            self.chartData = []
            self.isFetching = true
        }
       
        
        let data = try await APIManager.shared.fetchChartData(table: table, code: code, daysCount: count.rawValue)

        DispatchQueue.main.async {
            
            for rate in data.rates {
                self.chartData.append(ChartModel(value: rate.mid, date: rate.effectiveDate))
            }
            
            self.min = (data.rates.map { $0.mid }.min() ?? 0) * 0.99

            self.max = (data.rates.map { $0.mid }.max() ?? 0) * 1.01

            self.isFetching = false
            
            
        }
    }
}
