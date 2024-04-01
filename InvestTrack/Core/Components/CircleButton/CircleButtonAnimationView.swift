//
//  CircleButtonAnimationView.swift
//  InvestTrack
//
//  Created by Соня on 15.02.2024.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
//            .animation(animate ? Animation.easeOut(duration: 1.0) : .none)
            .animation(.easeOut(duration: 1.0), value: animate)
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
        .foregroundColor(.myRed)
        .frame(width: 100, height: 100)
}
