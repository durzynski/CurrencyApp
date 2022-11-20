//
//  CurrencyListViewController.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 09/11/2022.
//

import UIKit

class CurrencyListViewController: UIViewController {

    //MARK: - Properties
    
    private let currencyListViewModel = CurrencyListViewModel()
    
    //MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = K.appTitle
        label.textColor = Colors.neon
        
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = K.searchBarPlaceholder
        textField.leftViewMode = .always
        textField.backgroundColor = Colors.appSecondaryBackground
        textField.layer.cornerRadius = 24
        
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        let imageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))
        imageView.image = Icons.searchIcon
        imageView.tintColor = .systemGray2
        imageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(imageView)
        textField.leftView = iconContainer
        
        
        return textField
    }()
    
    private let tableTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = K.tableTitle
        label.textColor = .white
        
        return label
    }()
    
    private let currencyListTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CurrencyListTableViewCell.self, forCellReuseIdentifier: CurrencyListTableViewCell.identifier)
        table.backgroundColor = .clear
        
        return table
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.backgroundColor = .systemGray.withAlphaComponent(0.2)
        indicator.layer.cornerRadius = 10
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        
        return indicator
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchCurrenciesData(table: "a", daysAgoCount: 7)
        
        setupUI()
        setupNavigation()
        setupTableDelegates()
    }
}

//MARK: - SetupUI

extension CurrencyListViewController {
    
    func setupNavigation() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupUI() {
        
        view.backgroundColor = Colors.appBackgound
        view.addSubviews([activityIndicator, titleLabel, searchTextField, tableTitleLabel, currencyListTableView])

        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchTextField.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 3),
            searchTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: searchTextField.trailingAnchor, multiplier: 2),
            searchTextField.heightAnchor.constraint(equalToConstant: 65),
            
            tableTitleLabel.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            tableTitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: searchTextField.bottomAnchor, multiplier: 3),
            
            currencyListTableView.topAnchor.constraint(equalToSystemSpacingBelow: tableTitleLabel.bottomAnchor, multiplier: 1),
            currencyListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currencyListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            currencyListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor),
            
        ])
        
    }
    
    private func fetchCurrenciesData(table: String, daysAgoCount: Int) {
        
        activityIndicator.startAnimating()
        
        self.currencyListViewModel.fetchPastCurrenciesForTable(table: table, daysAgoCount: daysAgoCount) { [weak self] result in
            
            self?.currencyListViewModel.currencies = result ?? []

            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.currencyListTableView.reloadData()
            }
        }
        
    }
    
}

//MARK: - TableView DataSource and Delegate

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableDelegates() {
        currencyListTableView.dataSource = self
        currencyListTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyListViewModel.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListTableViewCell.identifier, for: indexPath) as? CurrencyListTableViewCell else {
            fatalError()
        }
        
        let viewModel = currencyListViewModel.currencies[indexPath.row]
        
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CurrencyListTableViewCell.preferredHeight
    }
    
}


