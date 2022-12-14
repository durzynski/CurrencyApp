//
//  AnnotationView.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 14/12/2022.
//

import SwiftUI

struct AnnotationView: View {
    
    @Binding var value: Double
    @Binding var date: String
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appBackgound)
                
                VStack(spacing: 4) {
                    Text(String(value.roundToFourDecimalPlaces()))
                        .font(.system(size: 16, weight: .medium))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Text(date)
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(Color.gray)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
            }
            .frame(width: 100, height: 50)
        }
    }
}
