//
//  DetailsScreen.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 09/12/2022.
//

import SwiftUI

struct DetailsScreen: View {
    
    var currencyViewModel: CurrencyViewModel
    @ObservedObject var chartViewModel: CurrencyChartViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(table: String, viewModel: CurrencyViewModel) {
        
        currencyViewModel = viewModel
        chartViewModel = CurrencyChartViewModel(table: table, code: viewModel.code)
        
    }
    
    var body: some View {
        VStack(spacing: 12) {

            
            HStack {
                NavBackView()
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
            }
            
            FlagView(flagName: currencyViewModel.flagName)
                .padding(.bottom)
            
            Text(currencyViewModel.code)
                .font(.system(size: 24, weight: .semibold))
            
            Text(currencyViewModel.name)
                .foregroundColor(.gray)
                .font(.system(size: 18, weight: .regular))
            
            HStack(spacing: 20) {
                Text(String(currencyViewModel.value))
                    .font(.system(size: 28, weight: .semibold))
                +
                
                Text(" \(K.polishCurrency)")
                    .foregroundColor(.neon)
                    .font(.system(size: 21))
                
                PercentageChangeView(value: currencyViewModel.percentChange ?? 0)
                
                Spacer()
            }
            .padding(.leading)
            .padding(.top)
            
            
            ChartView(viewModel: chartViewModel, selectedTopCount: $chartViewModel.count)
                .padding()
            
            Spacer()

        }
        .background(Color.appBackgound)
        .task {
            do {
                try await chartViewModel.fetchChartData()
            } catch {
                print(error)
            }
        }
        .toolbar(.hidden)
    }
}

struct DetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailsScreen(table: "A", viewModel: CurrencyViewModel(currency: Rate(currency: "Dolar amerykański", code: "USD", mid: 4.444)))
            .preferredColorScheme(.dark)
    }
}
