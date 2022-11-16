//
//  CurrencyListViewModel.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 15/11/2022.
//

import Foundation

class CurrencyListViewModel {
    
    var currencyTable: [ExchangeRatesTable] = []
    
    var currencies: [CurrencyViewModel] = []
    
    
    func fetchPastCurrenciesForTable(table: String, daysAgoCount: Int, completion: @escaping ([CurrencyViewModel]?) -> Void) {
        
        APIManager.shared.fetchCurrenciesForTable(table: table, daysAgoCount: daysAgoCount) { [weak self] result in
            
            switch result {
                
            case .success(let table):
                
                self?.currencyTable = table
                
                var pastCurrencyData: [CurrencyViewModel] = []
                var currentCurrencyData: [CurrencyViewModel] = []
                
                pastCurrencyData = table[0].rates.map {
                    CurrencyViewModel(currency: $0)
                }
                
                currentCurrencyData = table[daysAgoCount - 1].rates.map {
                    CurrencyViewModel(currency: $0)
                }
                
                var index = 0
                
                currentCurrencyData.forEach({ [weak self] currency in
                    
                    let percentChange = self?.calculatePercentChange(current: currency.currency.mid, past: pastCurrencyData[index].currency.mid )
                    
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
    
    func calculatePercentChange(current: Double, past: Double) -> Double {
        
        let percentChange = (((past - current) / past) * 100).roundToTwoDecimalPlaces()
        
        return percentChange
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
    
    var percentChange: Double?
    
}
