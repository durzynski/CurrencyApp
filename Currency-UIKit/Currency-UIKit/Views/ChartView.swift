//
//  ChartView.swift
//  Currency-UIKit
//
//  Created by Damian Durzyński on 28/11/2022.
//

import UIKit
import Charts

class ChartView: UIView {
    
    //MARK: - UI Elements
    
    let daysButton: UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Colors.appBackgound
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.image = Icons.arrowTriangleDownFill
        config.imagePlacement = .trailing
        config.title = K.last7
        config.buttonSize = .small
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.layer.transform = CATransform3DMakeScale(0.6, 0.5, 0)

        return button
    }()
    
    let lineChart: LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(false)
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = true
        chartView.xAxis.enabled = false
        chartView.noDataTextColor = Colors.neon ?? .white
        chartView.noDataFont = .systemFont(ofSize: 16, weight: .medium)
        chartView.noDataText = ""
        
        return chartView
    }()
    
    let marker = CustomMarkerView()
    
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

extension ChartView {
    
    private func setupUI() {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Colors.appSecondaryBackground
        layer.cornerRadius = 8
        
        addSubviews([daysButton, lineChart])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            daysButton.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            daysButton.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            
            lineChart.topAnchor.constraint(equalToSystemSpacingBelow: daysButton.bottomAnchor, multiplier: 1),
            lineChart.leadingAnchor.constraint(equalTo: daysButton.leadingAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: lineChart.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: lineChart.bottomAnchor, multiplier: 1),
        ])
        
    }
    
    public func configureChartData(with viewModel: CurrencyChartViewModel) {
        
        var entries = [ChartDataEntry]()
        
        for (index, value) in viewModel.values.enumerated() {
            entries.append(
                .init(x: Double(index), y: value)
            )
        }

        marker.chartView = lineChart
        lineChart.marker = marker
        lineChart.drawMarkers = true
        lineChart.animate(xAxisDuration: 0.35)
        
        let dataSet = LineChartDataSet(entries: entries, label: "")
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 2
        dataSet.setColor(Colors.neon ?? .white)
        dataSet.drawCirclesEnabled = false
        dataSet.fillColor = Colors.neon ?? .clear
        dataSet.drawFilledEnabled = true
        
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightColor = .systemGray
        dataSet.highlightLineWidth = 2
        dataSet.highlightLineDashLengths = [2]
        
        let data = LineChartData(dataSet: dataSet)
        data.setDrawValues(false)
    
        lineChart.data = data
    }
}
