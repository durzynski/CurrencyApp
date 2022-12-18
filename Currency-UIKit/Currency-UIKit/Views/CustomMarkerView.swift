//
//  AnnotationView.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 17/12/2022.
//

import UIKit
import Charts

class CustomMarkerView: MarkerView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    private func initUI() {
        
        
        Bundle.main.loadNibNamed(K.customMarkerName, owner: self, options: nil)
        addSubview(contentView)
        
        containerView.backgroundColor = Colors.appBackgound
        containerView.layer.cornerRadius = 8
        
        valueLabel.adjustsFontSizeToFitWidth = true
        dateLabel.adjustsFontSizeToFitWidth = true

        self.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        self.offset = CGPoint(x: -(self.frame.width/2), y: -self.frame.height - 40)
    }
}

