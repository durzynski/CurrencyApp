//
//  ShimmerView.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 08/12/2022.
//

import SwiftUI

struct ShimmerView: View {
    
    private struct Constants {
        static let duration: Double = 2
        static let minOpacity: Double = 0.25
        static let maxOpacity: Double = 1.0
    }
    
    @State private var opacity: Double = Constants.minOpacity
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Capsule()
                .fill(.gray.opacity(opacity))
                .frame(width: 50, height: 50)
                .padding(.horizontal)
            
            Capsule()
                .fill(.gray.opacity(opacity))
                .frame(width: 100, height: 60)
            
            Spacer()
            
            Capsule()
                .fill(.gray.opacity(opacity))
                .frame(width: 90, height: 40)
            
            Spacer()
            
            Capsule()
                .fill(.gray.opacity(opacity))
                .frame(width: 60, height: 40)
                .padding(.trailing)
            
        }
        .frame(height: 100)
        .background(Color.appBackgound)
        .onAppear {
            let baseAnimation = Animation.easeInOut(duration: Constants.duration)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            withAnimation(repeated) {
                self.opacity = Constants.maxOpacity
            }
        }
    }
}

struct ShimmerView_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerView()
            .preferredColorScheme(.dark)
    }
}
