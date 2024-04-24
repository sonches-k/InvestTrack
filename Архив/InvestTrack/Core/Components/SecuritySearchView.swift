//
//  SecuritySearchView.swift
//  InvestTrack
//
//  Created by Соня on 29.03.2024.
//

import SwiftUI

struct SecuritySearchView: View {
    
    let security: SecurityModel
    var body: some View {
        VStack {
            Text(security.securityId.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(security.name)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
            
        }
        
    }
}

