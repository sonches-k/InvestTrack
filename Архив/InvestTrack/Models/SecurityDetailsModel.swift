//
//  SecurityDetailsModel.swift
//  InvestTrack
//
//  Created by Соня on 19.04.2024.
//



import Foundation

// Ответ от сервера, содержащий детали о ценной бумаге
struct SecuritiesDetailResponse: Codable {
    let data: SecurityData
    let description: String
}

// Обертка для детальной информации о ценной бумаге
struct SecurityData: Codable {
    let security: SecurityDetailModel
}

// Модель, описывающая детали о конкретной ценной бумаге
struct SecurityDetailModel: Codable, Identifiable {
    let securityId: String
    let boardId: String
    let name: String
    let currentPrice: Double
    let priceChange24h: Double
    let priceChangePercentage24h: Double
    let lotSize: Int
    let history: [SecurityHistory]
    let analytics: SecurityAnalytics

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
}

//// История торгов, возможно пустая
//struct SecurityHistory: Codable {
//    let date: Date?
//    let openPrice: Double?
//    let lowPrice: Double?
//    let highPrice: Double?
//    let closePrice: Double?
//    let value: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case date
//        case openPrice = "open_price"
//        case lowPrice = "low_price"
//        case highPrice = "high_price"
//        case closePrice = "close_price"
//        case value
//    }
//}

// Аналитическая информация о ценной бумаге
//struct SecurityAnalytics: Codable {
//    let maxPrice: Double
//    let minPrice: Double
//    let purchaseVerdict: Int
//    let history: [AnalyticsHistory]  // Пустой массив history, если нет данных
//
//    enum CodingKeys: String, CodingKey {
//        case maxPrice = "max_price"
//        case minPrice = "min_price"
//        case purchaseVerdict = "purchase_verdict"
//        case history
//    }
//}

//// Исторические данные для аналитики, если есть
//struct AnalyticsHistory: Codable {
//    let date: Date?
//    let ema12: Double?
//    let ema26: Double?
//    let macd: Double?
//    let sma20: Double?
//    let rsi14: Double?
//    let bollingerUpper20: Double?
//    let bollingerLower20: Double?
//    let stochasticOscillator14: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case date
//        case ema12 = "ema_12"
//        case ema26 = "ema_26"
//        case macd
//        case sma20 = "sma_20"
//        case rsi14 = "rsi_14"
//        case bollingerUpper20 = "bollinger_upper_20"
//        case bollingerLower20 = "bollinger_lower_20"
//        case stochasticOscillator14 = "stochastic_oscillator_14"
//    }
//}
