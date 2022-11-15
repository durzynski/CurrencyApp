//
//  CurrencyListViewController.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 09/11/2022.
//

import UIKit

class CurrencyListViewController: UIViewController {

    let currencyListViewModel = CurrencyListViewModel()
    
    //MARK: - Properties
    
    //MARK: - UI Elements
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        currencyListViewModel.fetchPastCurrenciesForTable(table: "a", daysAgoCount: 30)
        
        
        // 4.497354497354501%
        setupUI()
    }
}

//MARK: - SetupUI

extension CurrencyListViewController {
    
    func setupUI() {
        
        view.backgroundColor = Colors.appBackgound
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        
    }
    
    
}



