//
//  CurrencyDetailsViewController.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 24/11/2022.
//

import UIKit
import Charts

class CurrencyDetailsViewController: UIViewController {
    
    private let currencyViewModel: CurrencyViewModel
    private let chartViewModel: CurrencyChartViewModel
    
    //MARK: - Properties
    
    private let navBackButton: UIButton = {
       
        var conf = UIButton.Configuration.filled()
        conf.baseBackgroundColor = Colors.appSecondaryBackground
        conf.baseForegroundColor = .white
        conf.cornerStyle = .capsule
        
        let button = UIButton(configuration: conf)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        
        return button
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let flagView = FlagView()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let percentageChangeView = PercentageChangeView()
    
    private let chartView: ChartView = ChartView()
    
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
    
    //MARK: - Init
    
    init(table: String, viewModel: CurrencyViewModel) {
        
        self.currencyViewModel = viewModel
        
        self.chartViewModel = CurrencyChartViewModel(table: table, code: viewModel.code)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        setupChartDelegate()
        fetchChartData()
    }
}

//MARK: - SetupUI

extension CurrencyDetailsViewController {
    
    private func setupUI() {
        
        view.backgroundColor = Colors.appBackgound
        view.addSubviews([navBackButton, infoStackView, valueLabel, percentageChangeView, chartView, activityIndicator])
        infoStackView.addArrangedSubview(flagView)
        infoStackView.addArrangedSubview(codeLabel)
        infoStackView.addArrangedSubview(nameLabel)
        
        configure(with: currencyViewModel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            navBackButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            navBackButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            navBackButton.heightAnchor.constraint(equalToConstant: 60),
            navBackButton.widthAnchor.constraint(equalTo: navBackButton.heightAnchor),
            
            infoStackView.topAnchor.constraint(equalToSystemSpacingBelow: navBackButton.bottomAnchor, multiplier: 4),
            infoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalToSystemSpacingBelow: infoStackView.bottomAnchor, multiplier: 6),
            valueLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            
            percentageChangeView.leadingAnchor.constraint(equalToSystemSpacingAfter: valueLabel.trailingAnchor, multiplier: 2),
            percentageChangeView.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor),
  
            chartView.topAnchor.constraint(equalToSystemSpacingBelow: percentageChangeView.bottomAnchor, multiplier: 2),
            chartView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: chartView.trailingAnchor, multiplier: 2),
            chartView.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: chartView.bottomAnchor, multiplier: 2),
            
            activityIndicator.centerXAnchor.constraint(equalTo: chartView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: chartView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor),
            
        ])
        
    }
    
    private func configure(with viewModel: CurrencyViewModel) {
        
        flagView.setupFlagImage(flagName: viewModel.flagName)
        codeLabel.text = viewModel.code
        nameLabel.text = viewModel.name
        
        let valueString = String(viewModel.value.roundToFourDecimalPlaces()) + " PLN"
        let range = NSRange(location: valueString.count - 3, length: 3)
        
        let attributedString = NSMutableAttributedString(string: valueString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.neon ?? .red, range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 21), range: range)
        valueLabel.attributedText = attributedString
        
        percentageChangeView.setupPercentageChange(value: viewModel.percentChange ?? 0)
    }

    private func fetchChartData() {

        chartViewModel.fetchChartData { [weak self] completion in


            DispatchQueue.main.async {
                self?.activityIndicator.startAnimating()
                
            }
            
            guard let chartViewModel = self?.chartViewModel else {
                return
            }
            
            if completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
                    self?.activityIndicator.stopAnimating()
                    self?.chartView.configureChartData(with: chartViewModel)
                    
                }
                
            } else {
                DispatchQueue.main.async {
                    
                    self?.activityIndicator.stopAnimating()
                    
                    self?.chartView.configureChartData(with: chartViewModel)
                    self?.chartView.lineChart.data = nil
                    self?.chartView.lineChart.noDataText = "Nie udało się pobrać danych"
                }
            }
        }
    }
    
}

//MARK: - Actions

extension CurrencyDetailsViewController {
    
    private func resetAndFetchChartData(count: TopCount) {
        
        percentageChangeView.setupPercentageChange(value: currencyViewModel.percentChange ?? 0)
        
        chartViewModel.count = count
        chartViewModel.values = []
        chartView.lineChart.data = nil
        fetchChartData()
    }
    
    private func setupActions() {
        
        navBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let last7 = UIAction(title: "Ostatnie 7 ") {  [weak self] _ in
            self?.chartView.daysButton.setTitle("Ostatnie 7 ", for: .normal)
            
            self?.resetAndFetchChartData(count: .last7)
            
        }
        
        let last30 = UIAction(title: "Ostatnie 30 ") {  [weak self] _ in
            self?.chartView.daysButton.setTitle("Ostatnie 30 ", for: .normal)
            
            self?.resetAndFetchChartData(count: .last30)
            
        }
        
        let last90 = UIAction(title: "Ostatnie 90 ") {  [weak self] _ in
            self?.chartView.daysButton.setTitle("Ostatnie 90 ", for: .normal)
            
            self?.resetAndFetchChartData(count: .last90)
            
        }
        
        let last180 = UIAction(title: "Ostatnie 180 ") {  [weak self] _ in
            self?.chartView.daysButton.setTitle("Ostatnie 180 ", for: .normal)
            
            self?.resetAndFetchChartData(count: .last180)
        }
        
        let menu = UIMenu(children: [last7, last30, last90, last180])
        
        chartView.daysButton.menu = menu
        chartView.daysButton.showsMenuAsPrimaryAction = true
    }
    
    @objc private func goBack() {
        
        navigationController?.popViewController(animated: true)
        
    }
}


//MARK: - ChartDelegate

extension CurrencyDetailsViewController: ChartViewDelegate {
    
    func setupChartDelegate() {
        chartView.lineChart.delegate = self
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let selectedValue = entry.y
        let currentValue = currencyViewModel.value

        let percentChange = Double().calculatePercentChange(current: currentValue, past: selectedValue)
        
        percentageChangeView.setupPercentageChange(value: percentChange)
        
    }
    
}
