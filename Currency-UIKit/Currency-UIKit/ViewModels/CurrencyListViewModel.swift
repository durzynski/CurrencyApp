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
    var pastCurrencies: [CurrencyViewModel] = []
    
    func fetchPastCurrenciesForTable(table: String, daysAgoCount: Int) {
        
        APIManager.shared.fetchCurrenciesForTable(table: table, daysAgoCount: daysAgoCount) { [weak self] result in
            
            switch result {
                
            case .success(let table):
                
                self?.currencyTable = table
                
                self?.pastCurrencies = table[daysAgoCount - 1].rates.map {
                    CurrencyViewModel(currency: $0)
                }
                
                self?.currencies = table[0].rates.map {
                    CurrencyViewModel(currency: $0)
                }
                
                var index = 0
                
                self?.currencies.forEach({ [weak self] currency in
                    
                    let percentChange = self?.calculatePercentChange(current: currency.currency.mid, past: self?.pastCurrencies[index].currency.mid ?? 0)
                    
                    currency.percentChange = percentChange
                    
                    index += 1
                })

            case .failure(let error):  print(error)
                
            }
        }
    }
    
    func calculatePercentChange(current: Double, past: Double) -> String {
        
        let percentChange = (((past - current) / past) * 100).roundToTwoDecimalPlaces()
        
        return "\(percentChange)%"
    }
    
}

class CurrencyViewModel {

    let currency: Rate
    
    init(currency: Rate) {
        self.currency = currency
    }
    
    var name: String {
        currency.currency
    }
    
    var code: String {
        currency.code
    }
    
    var value: Double {
        currency.mid
    }
    
    var percentChange: String?
    
}
