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

}
