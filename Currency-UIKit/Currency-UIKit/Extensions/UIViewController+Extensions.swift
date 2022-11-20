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
            let alert = UIAlertController(title: "Coś poszło nie tak", message: "Sprawdź swoje połączenie internetowe", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Spróbuj ponownie", style: .default, handler: { _ in
                fetchAgain()
            }))
            
            self.present(alert, animated: true)
        }
    }
}
