//
//  NavBackView.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 09/12/2022.
//

import SwiftUI

struct NavBackView: View {
    var body: some View {
        Circle()
            .fill(Color.appSecondaryBackground)
            .frame(width: 50, height: 50)
            .padding(.horizontal)
            .overlay(
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 18, height: 15)
                    .font(.title)
                    .foregroundColor(.white)
            )
    }
}

struct NavBackView_Previews: PreviewProvider {
    static var previews: some View {
        NavBackView()
    }
}
