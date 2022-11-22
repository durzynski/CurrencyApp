//
//  PercentageChangeCellView.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 16/11/2022.
//

import UIKit

class PercentageChangeCellView: UIView {
    
    //MARK: - UI Elements
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 18
        
        return view
    }()
    
    private let percentageChangeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let arrowIconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Configure UI

extension PercentageChangeCellView {
    
    private func setupUI() {
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.addSubview(percentageChangeStackView)
        percentageChangeStackView.addArrangedSubview(arrowIconView)
        percentageChangeStackView.addArrangedSubview(percentageLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 36),
            containerView.widthAnchor.constraint(equalToConstant: 80),
            
            percentageChangeStackView.topAnchor.constraint(equalToSystemSpacingBelow: containerView.topAnchor, multiplier: 1),
            percentageChangeStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 1),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: percentageChangeStackView.trailingAnchor, multiplier: 1),
            containerView.bottomAnchor.constraint(equalToSystemSpacingBelow: percentageChangeStackView.bottomAnchor, multiplier: 1),
        ])
        
    }
    
    public func setupPercentageChange(value: Double) {
        
        if value < 0 {
            
            let color = UIColor.systemRed
            
            arrowIconView.image = UIImage(systemName: "arrow.up")
            arrowIconView.tintColor = color
            containerView.layer.borderColor = color.cgColor
            containerView.backgroundColor = color.withAlphaComponent(0.1)
            percentageLabel.text = String(value * -1) + "%"
            percentageLabel.textColor = color
        } else if value > 0 {
            
            let color = UIColor.systemGreen
            
            arrowIconView.image = UIImage(systemName: "arrow.down")
            arrowIconView.tintColor = color
            containerView.layer.borderColor = color.cgColor
            containerView.backgroundColor = color.withAlphaComponent(0.1)
            percentageLabel.text = String(value) + "%"
            percentageLabel.textColor = color
        } else {
            
            let color = UIColor.systemGray
            
            arrowIconView.image = UIImage(systemName: "equal")
            arrowIconView.tintColor = color
            containerView.layer.borderColor = color.cgColor
            containerView.backgroundColor = color.withAlphaComponent(0.1)
            percentageLabel.text = "0.0%"
            percentageLabel.textColor = color
        }
        
    }
    
}
