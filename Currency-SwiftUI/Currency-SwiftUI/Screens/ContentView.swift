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
        NavigationStack {
            ZStack {
                
                Color.appBackgound
                    .ignoresSafeArea()
                
                VStack {
                    Picker("Table picker", selection: $selectedTable) {
                        ForEach(tables, id: \.self) {
                            Text($0)
                        }
                        .onChange(of: selectedTable) { table in
                            
                            Task {
                                await fetchData()
                            }
                        }
                    }
                    .padding()
                    .pickerStyle(.segmented)
                    
                    SearchTextFieldView(searchText: $searchText, viewModel: viewModel)
                        .padding(.horizontal)
                    
                    List {
                        
                        if viewModel.currencies.count == 0 {
                            
                            ForEach(0..<7) { index in
                                ShimmerView()
                                    .listRowInsets(EdgeInsets())
                            }
                        } else {
                            ForEach(viewModel.isSearching ? viewModel.filteredCurrencies : viewModel.currencies, id: \.code) { currency in
                                
                                ZStack {
                                    NavigationLink(destination: DetailsScreen(table: selectedTable, viewModel: currency)) {
                                        EmptyView()
                                    }
        
                                    CurrencyView(viewModel: currency)
                                        
                                }
                                .listRowInsets(EdgeInsets())

                            }
                        }
                    }
                    .listStyle(.plain)
                    .overlay {
                        if viewModel.isFetching {
                            ProgressView()
                                .scaleEffect(1.5)
                        }
                    }
                }
                .task {
                    
                    if viewModel.currencies.count == 0 {
                        await fetchData()
                    }
                }
            }
        }
    }
    
    func fetchData() async {
        do {
            try await viewModel.fetchPastCurrenciesForTable(table: selectedTable, daysAgoCount: 7)
        } catch {
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
