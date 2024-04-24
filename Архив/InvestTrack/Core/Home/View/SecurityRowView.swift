//
//  SecurityRowView.swift
//  InvestTrack
//
//  Created by Соня on 07.03.2024.
//

import SwiftUI

struct SecurityRowView: View {
    
    let security: SecurityModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.system(size: 17) )
        .background(
            Color.theme.background.opacity(0.001)
        )
    }
}


extension SecurityRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
           
            Text(security.securityId.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(security.currentHoldingsValue.asCurrencyWit2hDecimals())
                .bold()
            Text((security.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
        
    }
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(security.currentPrice.asCurrencyWit6hDecimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(security.priceChangePercentage24h.asPercentString() )
                .foregroundColor(
                    (security.priceChangePercentage24h ) >= 0 ?
                    Color.theme.green :
                        Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
        
    }
}
