//
//  PercentageChangeView.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 06/12/2022.
//

import SwiftUI

struct PercentageChangeView: View {
    
    var value: Double
    
    var image: String {
        if value < 0 {
            return "arrow.up"
        } else if value > 0 {
            return "arrow.down"
        } else {
            return "equal"
        }
    }
    
    var color: Color {
        if value < 0 {
            return .red
        } else if value > 0 {
            return .green
        } else {
            return .gray
        }
    }
    
    var text: String {
        if value < 0 {
            return "\(value * -1)" + "%"
        } else {
            return "\(value)" + "%"
        }
    }
    
    var body: some View {
        
            HStack(spacing: 8) {
             
                Image(systemName: image)
                    .foregroundColor(color)
                
                Text(text)
                    .foregroundColor(color)
                    .minimumScaleFactor(0.5)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
            }
            .frame(width: 90, height: 40)
            .overlay(
                Capsule()
                    .stroke(color, lineWidth: 1)
            )
            .background(Capsule().fill(color.opacity(0.1)))
            
    }
}

struct PercentageChangeView_Previews: PreviewProvider {
    static var previews: some View {
        PercentageChangeView(value: 14.02)
            .preferredColorScheme(.dark)
    }
}
