//
//  ContentView.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 05/12/2022.
//

import SwiftUI

struct ContentView: View {
    
    private let tables = ["A", "B"]
    @State var selectedTable: String = "A"
    
    var body: some View {
        ZStack {
            
            Color.appBackgound
                .ignoresSafeArea()
    
            
        }

    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
