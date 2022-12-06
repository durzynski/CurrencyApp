//
//  ContentView.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 05/12/2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = CurrencyListViewModel()
    
    @State private var searchText: String = ""
    
    private let tables = ["A", "B"]
    @State var selectedTable: String = "A"
    
    var body: some View {
        ZStack {
            
            Color.appBackgound
                .ignoresSafeArea()
    
            VStack {
                Picker("Table picker", selection: $selectedTable) {
                    ForEach(tables, id: \.self) {
                        Text($0)
                    }
                }
                .padding()
                .pickerStyle(.segmented)
                
                SearchTextFieldView(searchText: $searchText)
                    .padding(.horizontal)
                
                Spacer()
            }
            .task {
                do {
                    try await viewModel.fetchPastCurrenciesForTable(table: selectedTable, daysAgoCount: 7)
                } catch {
                    print(error)
                }
            }
            

        }
        .preferredColorScheme(.dark)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
