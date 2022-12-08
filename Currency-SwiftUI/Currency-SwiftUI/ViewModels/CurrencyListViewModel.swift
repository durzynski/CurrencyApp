//
//  CurrencyListViewModel.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 06/12/2022.
//

import SwiftUI

class CurrencyListViewModel: ObservableObject {
    
    @Published var currencies = [CurrencyViewModel]()
    @Published var filteredCurrencies = [CurrencyViewModel]()
    
    @Published var isFetching: Bool = false
    var isSearching: Bool = false
    
    public func fetchPastCurrenciesForTable(table: String, daysAgoCount: Int) async throws {
        
        DispatchQueue.main.async {
            self.isFetching = true
        }
        
        let currenciesResponse = try await APIManager.shared.fetchCurrenciesForTable(table: table, daysAgoCount: daysAgoCount)
        
        DispatchQueue.main.async {
            var pastCurrencyData: [CurrencyViewModel] = []
            var currentCurrencyData: [CurrencyViewModel] = []
            
            pastCurrencyData = currenciesResponse[0].rates.map {
                CurrencyViewModel(currency: $0)
            }
            
            currentCurrencyData = currenciesResponse[daysAgoCount - 1].rates.map {
                CurrencyViewModel(currency: $0)
            }
            
            var index = 0
            
            currentCurrencyData.forEach({ currency in
                
                let percentChange = Double().calculatePercentChange(current: currency.currency.mid, past: pastCurrencyData[index].currency.mid)
                
                currency.percentChange = percentChange
                
                index += 1
            })
            
            self.isFetching = false
            self.currencies = currentCurrencyData
        }
        
    }
    
}

class CurrencyViewModel {
    
    let currency: Rate
    
    init(currency: Rate) {
        self.currency = currency
    }
    
    var name: String {
        currency.currency.capitalized
    }
    
    var code: String {
        currency.code
    }
    
    var value: Double {
        currency.mid
    }
    
    var flagName: String {
        
        let lowercased = currency.code.lowercased()
        let dropLast = lowercased.dropLast()
        
        return String(dropLast)
    }
    
    var percentChange: Double?
    
}
