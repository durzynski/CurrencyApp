//
//  Constants.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 05/12/2022.
//

import SwiftUI

struct K  {
    
    /// API
    
    static let apiExchangeRatesForTableURL = "https://api.nbp.pl/api/exchangerates/tables/"
    static let urlForCurrencyRates = "https://api.nbp.pl/api/exchangerates/rates/"
    /// CurrencyListVC
    
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
    static let searchIcon = "magnifyingglass"
    static let arrowUp = "arrow.up"
    static let arrowDown = "arrow.down"
    static let arrowLeft = "arrow.left"
    static let equal = "equal"
    static let arrowTriangleDownFill = "arrowtriangle.down.fill"
}



extension Color {

    static let appBackgound = Color("appBackground")
    static let appSecondaryBackground = Color("appSecondaryBackground")
    static let neon = Color("neon")
}
