//
//  SearchBarView.swift
//  InvestTrack
//
//  Created by Соня on 27.03.2024.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            .foregroundColor(Color.theme.secondaryText)
            
            TextField("Search by name or ticker..", text: $searchText)
                .foregroundColor(
                    searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
                .disableAutocorrection(true)
                .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .foregroundColor(Color.theme.secondaryText)
                    .opacity(searchText.isEmpty ? 0 : 1)
                
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        searchText = ""
                    }
                , alignment: .trailing)
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 10)
        )
        .padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
