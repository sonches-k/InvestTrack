//
//  ContentView.swift
//  InvestTrack
//
//  Created by Соня on 15.02.2024.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack(spacing: 40) {
                Text("Accent Color")
                    .foregroundColor(Color.theme.accent)
                Text ("Secondary Text Color")
                    .foregroundColor(Color.theme.secondaryText)
                Text ("Green Color")
                    .foregroundColor(Color.theme.green)
                Text ("Red Color")
                    .foregroundColor(Color.theme.red)
            }
            .font(.headline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
