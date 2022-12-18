//
//  Double+Extensions.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 15/11/2022.
//

import Foundation

extension Double {
    
    func roundToTwoDecimalPlaces() -> Double {
        
        let double = self
        let rounded = (double * 100).rounded() / 100
    
        return rounded
    }
    
    func roundToFourDecimalPlaces() -> Double {
        
        let double = self
        let rounded = (double * 10000).rounded() / 10000
    
        return rounded
    }
    
    func calculatePercentChange(current: Double, past: Double) -> Double {
        
        let percentChange = (((past - current) / past) * 100).roundToTwoDecimalPlaces()
        
        return percentChange
    }
}
