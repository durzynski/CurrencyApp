//
//  FlagView.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 06/12/2022.
//

import SwiftUI

struct FlagView: View {
    
    var flagName: String
    
    var body: some View {
        
        ZStack {
            
            Circle()
                .stroke(.gray)
                .frame(width: 50, height: 50)
                .foregroundColor(.clear)
            
            Image(flagName)
                .resizable()
                .frame(width: 30, height: 30)
                .background(.gray)
                .clipShape(Circle())
                
            
        }
        
    }
}

struct FlagView_Previews: PreviewProvider {
    static var previews: some View {
        FlagView(flagName: "")
    }
}
