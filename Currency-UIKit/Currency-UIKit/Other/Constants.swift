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
    static let urlForCurrencyRates = "https://api.nbp.pl/api/exchangerates/rates/"
    // CurrencyListVC

    static let searchBarPlaceholder = "Szukaj walut"
    static let tableTitle = "Kursy walut"
    
    
    /// Error Alert
    
    static let errorTitle = "Coś poszło nie tak"
    static let errorMessage = "Sprawdź swoje połączenie internetowe"
    static let errorButtonTitle = "Spróbuj ponownie"
    
    /// Chart
    
    static let polishCurrency = "PLN"
    static let chartNoDataText = "Nie udało się pobrać danych"
    
    static let last7 = "Ostatnie 7 "
    static let last30 = "Ostatnie 30 "
    static let last90 = "Ostatnie 90 "
    static let last180 = "Ostatnie 180 "
    
    /// CustomMarker
    
    static let customMarkerName = "CustomMarker"
}

enum Icons {
    static let searchIcon = UIImage(systemName: "magnifyingglass")
    static let arrowUp = UIImage(systemName: "arrow.up")
    static let arrowDown = UIImage(systemName: "arrow.down")
    static let arrowLeft = UIImage(systemName: "arrow.left")
    static let equal = UIImage(systemName: "equal")
    static let arrowTriangleDownFill = UIImage(systemName: "arrowtriangle.down.fill")
}

enum Colors {

    static let appBackgound = UIColor(named: "appBackground")
    static let appSecondaryBackground = UIColor(named: "appSecondaryBackground")
    static let neon = UIColor(named: "neon")
   
    static var gradientDarkGrey: UIColor {
        return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    }
    static var gradientLightGrey: UIColor {
        return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
    }
}

