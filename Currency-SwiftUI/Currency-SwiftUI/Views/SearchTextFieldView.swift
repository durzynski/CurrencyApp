//
//  SearchTextFieldView.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 05/12/2022.
//

import SwiftUI

struct SearchTextFieldView: View {
    
    @Binding var searchText: String
    var viewModel: CurrencyListViewModel
    
    var body: some View {
        
            HStack {
                
                Image(systemName: Icons.searchIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(uiColor: UIColor.systemGray2))
                    .padding(.init(top: 20, leading: 20, bottom: 20, trailing: 5))
                    
                
                TextField(K.searchBarPlaceholder, text: $searchText)
                    .padding(.trailing, 20)
                    .onSubmit {
                        searchText = ""
                        viewModel.isSearching = false
                    }
                    .onChange(of: searchText) { _ in
                        
                        if searchText != "" {
                            viewModel.isSearching = true
                        }
                        
                        viewModel.filteredCurrencies = viewModel.currencies.filter({ result in
                            
                            let withCode = result.code.lowercased().contains(searchText.lowercased().trimmingCharacters(in: .whitespaces))
                            
                            let withName = result.name.lowercased().contains(searchText.lowercased().trimmingCharacters(in: .whitespaces))

                            if withCode != false {
                                return withCode
                            } else {
                                return withName
                            }
                        })
                    }
                    
                
            }
            .background(Color.appSecondaryBackground).clipShape(RoundedRectangle(cornerRadius: 16))
        
    }
}

struct SearchTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextFieldView(searchText: .constant(""), viewModel: CurrencyListViewModel())
            .preferredColorScheme(.dark)
    }
}
