//
//  CurrencyDetailsViewController.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 24/11/2022.
//

import UIKit

class CurrencyDetailsViewController: UIViewController {
    
    private let currencyViewModel: CurrencyViewModel
    
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
    
    private let flagView = FlagCellView()
    
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
    
    private let percentageChangeView = PercentageChangeCellView()
    
    //MARK: - Init
    
    init(viewModel: CurrencyViewModel) {
        
        self.currencyViewModel = viewModel
        
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
        
    }
    
    
}

//MARK: - SetupUI

extension CurrencyDetailsViewController {
    
    private func setupUI() {
        
        view.backgroundColor = Colors.appBackgound
        view.addSubviews([navBackButton, infoStackView, valueLabel, percentageChangeView])
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
    
}

//MARK: - Actions

extension CurrencyDetailsViewController {
    
    func setupActions() {
        
        navBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
    }
    
    @objc func goBack() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

