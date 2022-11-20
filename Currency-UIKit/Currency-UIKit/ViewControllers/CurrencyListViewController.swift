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
        table.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.identifier)
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
    
    private let refreshControl = UIRefreshControl()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCurrenciesData(table: "a", daysAgoCount: 7)
        
        setupUI()
        setupNavigation()
        setupTableDelegates()
        setupActions()
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
    

    
}

//MARK: - Actions

extension CurrencyListViewController {
    
    private func setupActions() {

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
    }

    @objc func refreshData() {
        
        fetchCurrenciesData(table: "a", daysAgoCount: 7, pulledToRefresh: true)
        
    }
    
    private func fetchCurrenciesData(table: String, daysAgoCount: Int, pulledToRefresh: Bool = false) {

        pulledToRefresh ? refreshControl.beginRefreshing() : activityIndicator.startAnimating()
        
        self.currencyListViewModel.fetchPastCurrenciesForTable(table: table, daysAgoCount: daysAgoCount) { [weak self] result in
            
            if let result = result {
                self?.currencyListViewModel.currencies = result
            } else {
                self?.presentErrorAlert {
                    self?.fetchCurrenciesData(table: table, daysAgoCount: daysAgoCount, pulledToRefresh: pulledToRefresh)
                }
            }

            DispatchQueue.main.async {
                pulledToRefresh ? self?.refreshControl.endRefreshing() : self?.activityIndicator.stopAnimating()
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
        currencyListTableView.refreshControl = refreshControl
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currencyListViewModel.currencies.count == 0 {
            return 6
        } else {
            return currencyListViewModel.currencies.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currencyListViewModel.currencies.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.identifier, for: indexPath) as? SkeletonCell else {
                fatalError()
            }
            
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListTableViewCell.identifier, for: indexPath) as? CurrencyListTableViewCell else {
                fatalError()
            }
            
            let viewModel = currencyListViewModel.currencies[indexPath.row]
            
            cell.configure(with: viewModel)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currencyListViewModel.currencies.count == 0 {
            return SkeletonCell.preferredHeight
        } else {
            return CurrencyListTableViewCell.preferredHeight
        }
    }
    
}


