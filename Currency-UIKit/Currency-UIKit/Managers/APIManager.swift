//
//  APIManager.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 14/11/2022.
//

import Foundation

enum APIError: Error {
    case decodingError, urlError, wrongResponse, noData
}

struct APIManager {
    
    static let shared = APIManager()
    
    public func fetchCurrenciesForTable(table: String, daysAgoCount: Int? = nil, completion: @escaping (Result<[ExchangeRatesTable], APIError>) -> Void) {
        
        var urlString = K.apiExchangeRatesForTableURL + table

        if let agoDaysCount = daysAgoCount {
            urlString += "/last/\(agoDaysCount)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.noData))
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.wrongResponse))
                return
            }
            
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let object = try decoder.decode([ExchangeRatesTable].self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(.decodingError))
                    return
                }
            }
        }
        task.resume()
    }
    
    public func fetchChartData(table: String, code: String, daysCount: Int, completion: @escaping (Result<Chart, APIError>) -> Void) {
        
        let urlString = K.urlForCurrencyRates + table + "/" + code + "/last/" + "\(daysCount)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { data, response, error in
         
            if error != nil {
                completion(.failure(.noData))
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.wrongResponse))
                return
            }
            
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let object = try decoder.decode(Chart.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(.decodingError))
                    return
                }
            }
            
        }
        task.resume()
    }
    
}
