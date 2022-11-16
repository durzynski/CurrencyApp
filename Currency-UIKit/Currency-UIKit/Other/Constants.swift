//
//  Constants.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 12/11/2022.
//

import UIKit

struct K  {
    
    // API
    
    static let apiExchangeRatesForTableURL = "https://api.nbp.pl/api/exchangerates/tables/"
    
    // CurrencyListVC
    
    static let appTitle = "Currencio"

    static let searchBarPlaceholder = "Szukaj walut"
    static let tableTitle = "Kursy walut"
    
}

enum Icons {
    static let searchIcon = UIImage(systemName: "magnifyingglass")
}

enum Colors {

    static let appBackgound = UIColor(named: "appBackground")
    static let appSecondaryBackground = UIColor(named: "appSecondaryBackground")
    static let neon = UIColor(named: "neon")
}
