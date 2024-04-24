//
//  File.swift
//  InvestTrack
//
//  Created by Соня on 07.03.2024.
//

import Foundation

// Основная обертка
struct SecuritiesResponse: Codable {
    let data: SecuritiesData
    let description: String
}


// Данные по ценным бумагам
struct SecuritiesData: Codable {
    let securities: [SecurityModel]
}

// Модель для каждой ценной бумаги
struct SecurityModel: Codable, Identifiable, Hashable {
    internal init(securityId: String, boardId: String, name: String, currentPrice: Double, priceChange24h: Double, priceChangePercentage24h: Double, lotSize: Int, history: [SecurityHistory]? = nil, analytics: SecurityAnalytics? = nil, currentHoldings: Double? = nil) {
        self.securityId = securityId
        self.boardId = boardId
        self.name = name
        self.currentPrice = currentPrice
        self.priceChange24h = priceChange24h
        self.priceChangePercentage24h = priceChangePercentage24h
        self.lotSize = lotSize
        self.history = history
        self.analytics = analytics
        self.currentHoldings = currentHoldings
    }
    
    
    static func == (lhs: SecurityModel, rhs: SecurityModel) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id) //  уникальный идентификатор для хэширования
        }
    
    init(from model: Security) {
        securityId = model.securityId
        boardId = model.boardId
        name = model.name
        currentPrice = Double.random(in: 0.5...1000).rounded(toPlaces: 2)
        priceChangePercentage24h = Double.random(in: -10...10)
        priceChange24h = currentPrice * priceChangePercentage24h
        lotSize = model.lotSize
        self.history = nil
        self.analytics = nil
        self.currentHoldings = Double.random(in: 0.5...1000).rounded(toPlaces: 2)
    }

    let securityId: String
    let boardId: String
    let name: String
    let currentPrice: Double
    let priceChange24h: Double
    let priceChangePercentage24h: Double
    let lotSize: Int
    let history: [SecurityHistory]?
    let analytics: SecurityAnalytics?
    
    var currentHoldings: Double?

    //  для соответствия протоколу Identifiable
    var id: String { securityId + boardId }

    enum CodingKeys: String, CodingKey {
        case securityId = "security_id"
        case boardId = "board_id"
        case name
        case currentPrice = "current_price"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case lotSize = "lot_size"
        case history
        case analytics
    }
    
    
    // с учетом лотности
        func updateHoldings(amount: Double) -> SecurityModel {
            let updatedHoldings = Double(lotSize) * amount
            return SecurityModel(
                securityId: securityId,
                boardId: boardId,
                name: name,
                currentPrice: currentPrice,
                priceChange24h: priceChange24h,
                priceChangePercentage24h: priceChangePercentage24h,
                lotSize: lotSize,
                history: history,
                analytics: analytics,
                currentHoldings: updatedHoldings // новое значение
            )
        }

        var currentHoldingsValue: Double {
            guard let holdings = currentHoldings else {
                return 0
            }
            return holdings * currentPrice // Учитываем лотность
        }
    
}

// История торгов по ценной бумаге
struct SecurityHistory: Codable, Identifiable {
    let id = UUID()
    let date: String
    let openPrice: Double
    let lowPrice: Double
    let highPrice: Double
    let closePrice: Double
    let value: Double

    enum CodingKeys: String, CodingKey {
        case date
        case openPrice = "open_price"
        case lowPrice = "low_price"
        case highPrice = "high_price"
        case closePrice = "close_price"
        case value
    }
}

// Аналитика
struct SecurityAnalytics: Codable {
    let maxPrice: Double
    let minPrice: Double
    let purchaseVerdict: Int
    let history: [AnalyticsHistory]

    enum CodingKeys: String, CodingKey {
        case maxPrice = "max_price"
        case minPrice = "min_price"
        case purchaseVerdict = "purchase_verdict"
        case history
    }
}

//  данные для аналитических показателей
struct AnalyticsHistory: Codable {
    let date: String
    let ema12: Double?
    let ema26: Double?
    let macd: Double?
    let sma20: Double?
    let rsi14: Double?
    let bollingerUpper20: Double?
    let bollingerLower20: Double?
    let stochasticOscillator14: Double?

    enum CodingKeys: String, CodingKey {
        case date
        case ema12 = "ema_12"
        case ema26 = "ema_26"
        case macd
        case sma20 = "sma_20"
        case rsi14 = "rsi_14"
        case bollingerUpper20 = "bollinger_upper_20"
        case bollingerLower20 = "bollinger_lower_20"
        case stochasticOscillator14 = "stochastic_oscillator_14"
    }
}



