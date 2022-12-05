//
//  Constants.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 05/12/2022.
//

import SwiftUI

struct K  {
    
    // API
    
    static let apiExchangeRatesForTableURL = "https://api.nbp.pl/api/exchangerates/tables/"
    static let urlForCurrencyRates = "https://api.nbp.pl/api/exchangerates/rates/"
    // CurrencyListVC
    
    static let appTitle = "Currencio"

    static let searchBarPlaceholder = "Szukaj walut"
    static let tableTitle = "Kursy walut"
    
}

enum Icons {
    static let searchIcon = Image(systemName: "magnifyingglass")
}

extension Color {

    static let appBackgound = Color("appBackground")
    static let appSecondaryBackground = Color("appSecondaryBackground")
    static let neon = Color("neon")
}
