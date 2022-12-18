//
//  UIViewController+Extensions.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 20/11/2022.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(fetchAgain: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: K.errorTitle, message: K.errorMessage, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: K.errorButtonTitle, style: .default, handler: { _ in
                fetchAgain()
            }))
            
            self.present(alert, animated: true)
        }
    }
}
