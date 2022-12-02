//
//  SkeletonCell.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 20/11/2022.
//

import UIKit

class SkeletonCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "SkeletonCell"
    
    static let preferredHeight = CGFloat(100)

    //MARK: - UI Elements
    
    private let flagCellView = FlagView()
    
    private let flagLayer = CAGradientLayer()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        
        return stackView
    }()
    
    private let stackLayer = CAGradientLayer()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        return label
    }()
    
    private let valueLabelLayer = CAGradientLayer()
    
    private let percentageChangeView = PercentageChangeView()
    
    private let percentageViewLayer = CAGradientLayer()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flagLayer.frame = flagCellView.bounds
        flagLayer.cornerRadius = flagCellView.bounds.height / 2
        
        stackLayer.frame = labelStackView.bounds
        stackLayer.cornerRadius = labelStackView.bounds.height / 2
        
        valueLabelLayer.frame = valueLabel.bounds
        valueLabelLayer.cornerRadius = valueLabel.bounds.height / 2
        
        percentageViewLayer.frame = percentageChangeView.bounds
        percentageViewLayer.cornerRadius = percentageChangeView.bounds.height / 2
    }
    
}

//MARK: - Setup UI

extension SkeletonCell {
    
    private func setupUI() {
        
        /// Layers
        
        flagLayer.startPoint = CGPoint(x: 0, y: 0.5)
        flagLayer.endPoint = CGPoint(x: 1, y: 0.5)
        flagCellView.layer.addSublayer(flagLayer)
        
        stackLayer.startPoint = CGPoint(x: 0, y: 0.5)
        stackLayer.endPoint = CGPoint(x: 1, y: 0.5)
        labelStackView.layer.addSublayer(stackLayer)
        
        percentageViewLayer.startPoint = CGPoint(x: 0, y: 0.5)
        percentageViewLayer.endPoint = CGPoint(x: 1, y: 0.5)
        percentageChangeView.layer.addSublayer(percentageViewLayer)
        
        valueLabelLayer.startPoint = CGPoint(x: 0, y: 0.5)
        valueLabelLayer.endPoint = CGPoint(x: 1, y: 0.5)
        valueLabel.layer.addSublayer(valueLabelLayer)

        
        let flagGroup = makeAnimationGroup()
        flagGroup.beginTime = 0.0
        flagLayer.add(flagGroup, forKey: "backgroundColor")
        
        let stackGroup = makeAnimationGroup(previousGroup: flagGroup)
        stackLayer.add(stackGroup, forKey: "backgroundColor")
        
        let percentageGroup = makeAnimationGroup(previousGroup: stackGroup)
        percentageViewLayer.add(percentageGroup, forKey: "backgroundColor")
        
        let valueGroup = makeAnimationGroup(previousGroup: percentageGroup)
        valueLabelLayer.add(valueGroup, forKey: "backgroundColor")
        
        /// Add Subviews
        
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
            
            flagCellView.widthAnchor.constraint(equalToConstant: 50),
            flagCellView.heightAnchor.constraint(equalToConstant: 50),
            
            labelStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: flagCellView.trailingAnchor, multiplier: 2),
            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: percentageChangeView.leadingAnchor, constant: -8),
            labelStackView.heightAnchor.constraint(equalToConstant: 50),
            
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: valueLabel.trailingAnchor, multiplier: 2),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 60),
            valueLabel.heightAnchor.constraint(equalToConstant: 20),
            
            percentageChangeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: percentageChangeView.trailingAnchor, multiplier: 2),
            
            
        ])
        
    }
    
    
    func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
        let animDuration: CFTimeInterval = 1
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.gradientLightGrey.cgColor
        anim1.toValue = UIColor.systemGray.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0
        
        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.systemGray.cgColor
        anim2.toValue = UIColor.gradientLightGrey.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration
        
        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false
        
        if let previousGroup = previousGroup {
            group.beginTime = previousGroup.beginTime + 0.33
        }
        
        return group
    }
    
}


extension UIColor {
    static var gradientDarkGrey: UIColor {
        return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    }

    static var gradientLightGrey: UIColor {
        return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
    }
}

