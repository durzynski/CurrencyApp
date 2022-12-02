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
    
    private var isSearching: Bool = false
    //MARK: - UI Elements
    
    private var tablePicker = UISegmentedControl()
    
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
        indicator.backgroundColor = .systemGray.withAlphaComponent(0.5)
        indicator.layer.cornerRadius = 10
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        
        return indicator
    }()
    
    private let refreshControl = UIRefreshControl()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCurrenciesData(table: currencyListViewModel.currentTable, daysAgoCount: 7)
        
        setupUI()
        setupNavigation()
        setupTableDelegates()
        setupTextFieldDelegate()
        setupActions()
    }
}

//MARK: - SetupUI

extension CurrencyListViewController {
    
    func setupNavigation() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupUI() {
        
        setupSegmentedControl()
        
        view.backgroundColor = Colors.appBackgound
        view.addSubviews([searchTextField, tablePicker, tableTitleLabel, currencyListTableView, activityIndicator])

        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tablePicker.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            tablePicker.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tablePicker.trailingAnchor, multiplier: 2),
            tablePicker.heightAnchor.constraint(equalToConstant: 35),
            
            searchTextField.topAnchor.constraint(equalToSystemSpacingBelow: tablePicker.bottomAnchor, multiplier: 2),
            searchTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: searchTextField.trailingAnchor, multiplier: 2),
            searchTextField.heightAnchor.constraint(equalToConstant: 65),

            tableTitleLabel.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            tableTitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: searchTextField.bottomAnchor, multiplier: 3),

            currencyListTableView.topAnchor.constraint(equalToSystemSpacingBelow: tableTitleLabel.bottomAnchor, multiplier: 1),
            currencyListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currencyListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            currencyListTableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor),
            
        ])
        
    }
    
    func setupSegmentedControl() {
        
        tablePicker = UISegmentedControl(items: currencyListViewModel.tables)
        tablePicker.translatesAutoresizingMaskIntoConstraints = false
        tablePicker.selectedSegmentIndex = 0
        tablePicker.addTarget(self, action: #selector(changeTable), for: .valueChanged)
        
    }
    
}

//MARK: - Actions

extension CurrencyListViewController {
    
    private func setupActions() {

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        tablePicker = UISegmentedControl(items: currencyListViewModel.tables)
        
        tablePicker.addTarget(self, action: #selector(changeTable(_:)), for: .valueChanged)
        tablePicker.backgroundColor = .red

    }
    
    @objc func changeTable(_ sender: UISegmentedControl) {
        
        
        
        switch sender.selectedSegmentIndex {
        case 0: currencyListViewModel.currentTable = "A"
            fetchCurrenciesData(table: currencyListViewModel.currentTable, daysAgoCount: 7)
            
        case 1: currencyListViewModel.currentTable = "B"
            fetchCurrenciesData(table: currencyListViewModel.currentTable, daysAgoCount: 7)
            
        default: currencyListViewModel.currentTable = "A"
            fetchCurrenciesData(table: currencyListViewModel.currentTable, daysAgoCount: 7)
            
        }
        
    }

    @objc func refreshData() {
        
        fetchCurrenciesData(table: currencyListViewModel.currentTable, daysAgoCount: 7, pulledToRefresh: true)
        
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
        } else if isSearching {
            return currencyListViewModel.filteredCurrencies.count
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
        } else if isSearching {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListTableViewCell.identifier, for: indexPath) as? CurrencyListTableViewCell else {
                fatalError()
            }
            
            let viewModel = currencyListViewModel.filteredCurrencies[indexPath.row]
            
            cell.configure(with: viewModel)
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if currencyListViewModel.currencies.count != 0 {
            let viewModel = currencyListViewModel.currencies[indexPath.row]
            let vc = CurrencyDetailsViewController(table: currencyListViewModel.currentTable, viewModel: viewModel)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: - TextField Delegate

extension CurrencyListViewController: UITextFieldDelegate {
    
    private func setupTextFieldDelegate() {
        searchTextField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let searchtext = searchTextField.text! + string
        
        if searchtext == "" {
            isSearching = false
            
            self.currencyListTableView.reloadData()
        } else {
            isSearching = true
            
            currencyListViewModel.filteredCurrencies = currencyListViewModel.currencies.filter({ result in
                
                let withCode = result.code.lowercased().contains(searchtext.lowercased().trimmingCharacters(in: .whitespaces))
                
                let withName = result.name.lowercased().contains(searchtext.lowercased().trimmingCharacters(in: .whitespaces))

                if withCode != false {
                    return withCode
                } else {
                    return withName
                }

            })
            
            self.currencyListTableView.reloadData()
        }

        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        
        return true
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        isSearching = false

        self.currencyListTableView.reloadData()
    }
    
    
}

