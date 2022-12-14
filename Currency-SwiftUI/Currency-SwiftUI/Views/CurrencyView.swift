//
//  CurrencyView.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 06/12/2022.
//

import SwiftUI

struct CurrencyView: View {
    
    var viewModel: CurrencyViewModel
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            FlagView(flagName: viewModel.flagName)
                .padding(.leading)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.code)
                    .font(.system(size: 16, weight: .semibold))
                
                
                Text(viewModel.name)
                    .font(.system(size: 14, weight: .regular))
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                
                PercentageChangeView(value: viewModel.percentChange ?? 0)
                
                Text(String(viewModel.value.roundToFourDecimalPlaces()))
                    .frame(width: 80)
                    .font(.system(size: 16, weight: .semibold))
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                    .multilineTextAlignment(.trailing)
                    .padding(.trailing, 5)
                
            }
        }
        .frame(height: 100)
        .background(Color.appBackgound)

    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(viewModel: CurrencyViewModel(currency: Rate(currency: "Dolar amerykański", code: "USD", mid: 4.55555)))
            .preferredColorScheme(.dark)
    }
}
