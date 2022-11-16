//
//  CurrencyListTableViewCell.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 16/11/2022.
//

import UIKit

class CurrencyListTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = String(describing: CurrencyListTableViewCell.self)
    
    static let preferredHeight = CGFloat(100)
    
    //MARK: - UI Elements
    
    private let flagCellView = FlagCellView()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    private let percentageChangeView = PercentageChangeCellView()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

//MARK: - Setup UI

extension CurrencyListTableViewCell {
    
    private func setupUI() {
        
        contentView.backgroundColor = Colors.appBackgound
        contentView.addSubviews([flagCellView, labelStackView, valueLabel, percentageChangeView])
        
        labelStackView.addArrangedSubview(codeLabel)
        labelStackView.addArrangedSubview(nameLabel)
        
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            flagCellView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            flagCellView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            labelStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: flagCellView.trailingAnchor, multiplier: 2),
            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: percentageChangeView.leadingAnchor, constant: -8),
            
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: valueLabel.trailingAnchor, multiplier: 2),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 60),
            
            percentageChangeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: percentageChangeView.trailingAnchor, multiplier: 2),
            
            
        ])
        
    }
    
    
    public func configure(with viewModel: CurrencyViewModel) {
        
        flagCellView.setupFlagImage(flagName: "")
        
        codeLabel.text = viewModel.code
        nameLabel.text = viewModel.name
        valueLabel.text = String(viewModel.value.roundToFourDecimalPlaces())
        
        percentageChangeView.setupPercentageChange(value: viewModel.percentChange ?? 0)
        
    }
    
}
