//
//  CurrencyListViewModel.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 15/11/2022.
//

import Foundation

class CurrencyListViewModel {
    
    var currencies: [CurrencyViewModel] = []
    var filteredCurrencies: [CurrencyViewModel] = []
    
    let tables = ["A", "B"]
    var currentTable: String = "A"
    
    func fetchPastCurrenciesForTable(table: String, daysAgoCount: Int, completion: @escaping ([CurrencyViewModel]?) -> Void) {
        
        APIManager.shared.fetchCurrenciesForTable(table: table, daysAgoCount: daysAgoCount) { result in
            
            switch result {
                
            case .success(let table):
                
                var pastCurrencyData: [CurrencyViewModel] = []
                var currentCurrencyData: [CurrencyViewModel] = []
                
                pastCurrencyData = table[0].rates.map {
                    CurrencyViewModel(currency: $0)
                }
                
                currentCurrencyData = table[daysAgoCount - 1].rates.map {
                    CurrencyViewModel(currency: $0)
                }
                
                var index = 0
                
                currentCurrencyData.forEach({ currency in
                    
                    let percentChange = Double().calculatePercentChange(current: currency.currency.mid, past: pastCurrencyData[index].currency.mid )
                    
                    currency.percentChange = percentChange
                    
                    index += 1
                })

                completion(currentCurrencyData)

            case .failure(let error):
                print(error)
                completion(nil)
            }
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
        let svg = dropLast + ".svg"
        
        return String(svg)
        
    }
    
    var percentChange: Double?
}
