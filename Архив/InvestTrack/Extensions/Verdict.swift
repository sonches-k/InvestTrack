//
//  Verdict.swift
//  InvestTrack
//
//  Created by Соня on 19.04.2024.
//

import Foundation

enum PurchaseVerdict: Int {
    case strongBuy = 1
    case buy = 2
    case hold = 3
    case sell = 4
    case strongSell = 5

    var description: String {
        switch self {
        case .strongBuy:
            return "Strong Buy"
        case .buy:
            return "Buy"
        case .hold:
            return "Hold"
        case .sell:
            return "Sell"
        case .strongSell:
            return "Strong Sell"
        }
    }
}

