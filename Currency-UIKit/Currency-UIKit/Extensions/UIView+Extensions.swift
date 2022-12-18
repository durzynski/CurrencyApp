//
//  UIView+Extensions.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 15/11/2022.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
}
