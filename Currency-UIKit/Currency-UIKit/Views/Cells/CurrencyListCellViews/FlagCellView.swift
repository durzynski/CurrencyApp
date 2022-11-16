//
//  FlagCellView.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 16/11/2022.
//

import UIKit

class FlagCellView: UIView {
    
    //MARK: - UI Elements
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 25
        
        return view
    }()
    
    private let flagImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 15

        return view
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

extension FlagCellView {
    
    private func setupUI() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageContainerView)
        imageContainerView.addSubview(flagImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageContainerView.heightAnchor.constraint(equalToConstant: 50),
            imageContainerView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            
            flagImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            flagImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            flagImageView.heightAnchor.constraint(equalToConstant: 30),
            flagImageView.widthAnchor.constraint(equalTo: flagImageView.heightAnchor),
        ])
        
    }
    
    public func setupFlagImage(flagName: String) {
        
        //flagImageView.image = UIImage(named: flagName)
        
    }
    
}

