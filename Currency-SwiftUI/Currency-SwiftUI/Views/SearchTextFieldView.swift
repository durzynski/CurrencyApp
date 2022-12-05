//
//  SearchTextFieldView.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 05/12/2022.
//

import SwiftUI

struct SearchTextFieldView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        
            HStack {
                
                Image(systemName: Icons.searchIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(uiColor: UIColor.systemGray2))
                    .padding(.init(top: 20, leading: 20, bottom: 20, trailing: 5))
                    
                
                TextField("Szukaj walut", text: $searchText)
                    .padding(.trailing, 20)
                
            }
            .background(Color.appSecondaryBackground).clipShape(RoundedRectangle(cornerRadius: 16))
        
    }
}

struct SearchTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextFieldView(searchText: .constant(""))
    }
}
