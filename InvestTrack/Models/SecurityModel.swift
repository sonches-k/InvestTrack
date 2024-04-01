//
//  File.swift
//  InvestTrack
//
//  Created by Соня on 07.03.2024.
//

import Foundation

// CoinGecko API info
/*
 URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 
 JSON Response:
 {
 "id": "bitcoin",
 "symbol": "btc",
 "name": "Bitcoin",
 "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
 "current_price": 58908,
 "market_cap": 1100013258170,
 "market_cap_rank": 1,
 "fully_diluted_valuation": 1235028318246,
 "total_volume": 69075964521,
 "high_24h": 59504,
 "low_24h": 57672,
 "price_change_24h": 808.94,
 "price_change_percentage_24h": 1.39234,
 "market_cap_change_24h": 13240944103,
 "market_cap_change_percentage_24h": 1.21837,
 "circulating_supply": 18704250,
 "total_supply": 21000000,
 "max_supply": 21000000,
 "ath": 64805,
 "ath_change_percentage": -9.24909,
 "ath_date": "2021-04-14T11:54:46.763Z",
 "atl": 67.81,
 "atl_change_percentage": 86630.1867,
 "atl_date": "2013-07-06T00:00:00.000Z",
 "roi": null,
 "last_updated": "2021-05-09T04:06:09.766Z",
 "sparkline_in_7d": {
 "price": [
 57812.96915967891,
 57504.33531773738,
 ]
 },
 "price_change_percentage_24h_in_currency": 1.3923423473152687
 }
 
 */
import Foundation

// Основная обертка для данных
struct SecuritiesResponse: Codable {
    let data: SecuritiesData
    let description: String
}

// Данные по ценным бумагам
struct SecuritiesData: Codable {
    let securities: [SecurityModel]
}

// Модель для каждой ценной бумаги
struct SecurityModel: Codable, Identifiable {
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

    // Уникальный идентификатор для соответствия протоколу Identifiable
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
    
    // Метод для обновления владения ценной бумагой с учетом лотности
        func updateHoldings(amount: Double) -> SecurityModel {
            let updatedHoldings = Double(lotSize) * amount // Учитываем лотность
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
                currentHoldings: updatedHoldings // Устанавливаем новое значение для текущего владения
            )
        }

        // Вычисляемая свойство для текущей стоимости владения ценной бумагой с учетом лотности
        var currentHoldingsValue: Double {
            guard let holdings = currentHoldings else {
                return 0 // Если владение не указано, возвращаем 0
            }
            return holdings * currentPrice // Учитываем лотность
        }
    
}

// История торгов по ценной бумаге
struct SecurityHistory: Codable {
    let date: Date
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

// Аналитика ценной бумаги
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

// Исторические данные для аналитических показателей
struct AnalyticsHistory: Codable {
    let date: Date
    let ema12: Double
    let ema26: Double
    let macd: Double
    let sma20: Double
    let rsi14: Double
    let bollingerUpper20: Double
    let bollingerLower20: Double
    let stochasticOscillator14: Double

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


 
// тут моя моделька
//struct SecurityModel: Identifiable, Codable {
//    let id, symbol, name: String
//    let image: String
//    let currentPrice: Double
//    let marketCap, marketCapRank, fullyDilutedValuation: Double?
//    let totalVolume, high24H, low24H: Double?
//    let priceChange24H, priceChangePercentage24H: Double?
//    let marketCapChange24H: Double?
//    let marketCapChangePercentage24H: Double?
//    let circulatingSupply, totalSupply, maxSupply, ath: Double?
//    let athChangePercentage: Double?
//    let athDate: String?
//    let atl, atlChangePercentage: Double?
//    let atlDate: String?
//    let lastUpdated: String?
//    let sparklineIn7D: SparklineIn7D?
//    let priceChangePercentage24HInCurrency: Double?
//    let currentHoldings: Double?
//    
//    enum CodingKeys: String, CodingKey {
//        case id, symbol, name, image
//        case currentPrice = "current_price"
//        case marketCap = "market_cap"
//        case marketCapRank = "market_cap_rank"
//        case fullyDilutedValuation = "fully_diluted_valuation"
//        case totalVolume = "total_volume"
//        case high24H = "high_24h"
//        case low24H = "low_24h"
//        case priceChange24H = "price_change_24h"
//        case priceChangePercentage24H = "price_change_percentage_24h"
//        case marketCapChange24H = "market_cap_change_24h"
//        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
//        case circulatingSupply = "circulating_supply"
//        case totalSupply = "total_supply"
//        case maxSupply = "max_supply"
//        case ath
//        case athChangePercentage = "ath_change_percentage"
//        case athDate = "ath_date"
//        case atl
//        case atlChangePercentage = "atl_change_percentage"
//        case atlDate = "atl_date"
//        case lastUpdated = "last_updated"
//        case sparklineIn7D = "sparkline_in_7d"
//        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
//        case currentHoldings
//    }
//    
//    // тут учесть лотность тоже
//    func updateHoldings(amount: Double) -> SecurityModel {
//        return SecurityModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
//    }
     // тут лотность должна быть
//    var currentHoldingsValue: Double {
//        return (currentHoldings ?? 0) * currentPrice
//    }
//    

