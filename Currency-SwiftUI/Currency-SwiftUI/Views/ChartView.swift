//
//  ChartView.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 09/12/2022.
//

import SwiftUI
import Charts


struct ChartView: View {
    
    let topCounts: [TopCount] = [.last7, .last30, .last90, .last180]
    
    var viewModel: CurrencyChartViewModel
    
    @State var selectedDate: String = ""
    @State var selectedValue: Double = 0
    @State var position: CGPoint = CGPoint(x: 0, y: 0)
    @State var annotationHidden: Bool = true
    
    
    @Binding var selectedTopCount: TopCount
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appSecondaryBackground)
            
            VStack(spacing: 8) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.appBackgound)
                            .frame(width: 100, height: 40)
                        
                        Menu {
                            ForEach(topCounts, id: \.self) { topCount in
                                Button("Ostatnie \(topCount.rawValue)") {
                                    
                                    selectedTopCount = topCount
                                    
                                    viewModel.count = topCount
                                    
                                    Task {
                                        try await viewModel.fetchChartData()
                                    }
                                }
                            }
                        } label: {
                            
                            HStack {
                                Text("Ostatnie \(selectedTopCount.rawValue)")
                                
                                Image(systemName: "arrowtriangle.down.fill")
                                    .scaleEffect(0.65)
                            }
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: 90, height: 40)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                        .padding(10)
                        
                        
                    }
                    Spacer()
                }
                
                Chart {
                    
                    ForEach(viewModel.chartData, id: \.id) { data in
                        
                        LineMark(x: .value("Date", data.date),
                                 y: .value("Value", data.value))
                        .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
                        .interpolationMethod(.cardinal)
                        .foregroundStyle(Color.neon)
                        
                    }
                    
                    ForEach(viewModel.chartData, id: \.id) { data in
                        
                        if !annotationHidden && selectedDate != "" {
                            RuleMark(x: .value("Date", selectedDate))
                                .foregroundStyle(Color.gray)
                                .lineStyle(StrokeStyle(lineWidth: 0.5, dash: [4]))
                            
                            PointMark(x: .value("Date", selectedDate),
                                     y: .value("Value", selectedValue))
                            .foregroundStyle(Color.neon)
                        }
                    }
                }
                .padding()
                .chartXAxis(.hidden)
                .chartYScale(domain: viewModel.min...viewModel.max)
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        
                                        configureAnnotation(proxy: proxy, location: gesture.location, geometry: geometry)
                                    }
                                    .onEnded{ _ in
                                        annotationHidden = true
                                    }
                            )
                            .onTapGesture { location in
                                configureAnnotation(proxy: proxy, location: location, geometry: geometry)
                            }
                    }
                    
                }
                .overlay {
                    AnnotationView(value: $selectedValue, date: $selectedDate)
                        .opacity(annotationHidden ? 0 : 1)
                        .position(CGPoint(x: position.x, y: position.y - 40))
                    
                    if viewModel.isFetching {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
            }

        }
    }
    
    private func configureAnnotation(proxy: ChartProxy, location: CGPoint, geometry: GeometryProxy) {
        
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x

        guard let date: String = proxy.value(atX: xPosition) else {
            return
        }
        
        selectedDate = date
        selectedValue = viewModel.chartData.first (where: { model in
            model.date == date
        })?.value ?? 0
        
        position = location
        annotationHidden = false
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: CurrencyChartViewModel(table: "A", code: "USD"), selectedTopCount: .constant(.last7))
    }
}

