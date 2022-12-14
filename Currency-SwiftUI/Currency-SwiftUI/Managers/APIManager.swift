//
//  APIManager.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 06/12/2022.
//

import Foundation

enum APIError: Error {
    case decodingError
    case urlError
    case wrongResponse
    case noData
}

class APIManager {
    
    static let shared = APIManager()
    
    public func fetchCurrenciesForTable(table: String, daysAgoCount: Int? = nil) async throws -> [ExchangeRatesTable]  {
        
        var urlString = K.apiExchangeRatesForTableURL + table
        
        if let agoDaysCount = daysAgoCount {
            urlString += "/last/\(agoDaysCount)"
        }
        
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        let session = URLSession(configuration: config)
        
        let (data, response) = try await session.data(from: url)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        guard statusCode == 200 else {
            throw APIError.wrongResponse
        }
        
        guard let object = try? JSONDecoder().decode([ExchangeRatesTable].self, from: data) else {
            throw APIError.decodingError
        }
        
        return object
        
    }
    
    public func fetchChartData(table: String, code: String, daysCount: Int) async throws -> ChartResponse {
        
        let urlString = K.urlForCurrencyRates + table + "/" + code + "/last/" + "\(daysCount)"
        
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        let session = URLSession(configuration: config)
        
        let (data, response) = try await session.data(from: url)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        guard statusCode == 200 else {
            throw APIError.wrongResponse
        }
        
        guard let object = try? JSONDecoder().decode(ChartResponse.self, from: data) else {
            throw APIError.decodingError
        }
        
        return object
        
    }
    
}
