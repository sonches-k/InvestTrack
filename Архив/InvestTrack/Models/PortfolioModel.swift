//
//  PortfolioModel.swift
//  InvestTrack
//
//  Created by Соня on 22.04.2024.
//

import Foundation

struct PortfolioRequest: Codable {
    var access_token: String
    var security_id: String
    var board_id: String
    var amount: Int
    
    func encodeToJSONData() -> Data {
        return (try? JSONEncoder().encode(self)) ?? Data()
    }
}


struct PortfolioResponse: Codable {
    let data: PortfolioData
    let description: String
}

struct PortfolioData: Codable {
    let securities: [Security]
}

struct Security: Codable, Identifiable {
    let id: Int
    let securityId: String
    let boardId: String
    let name: String
    let lotSize: Int
    let amount: Int
    
    enum CodingKeys: String, CodingKey {
            case id
            case securityId = "security_id"
            case boardId = "board_id"
            case name
            case lotSize = "lot_size"
            case amount
        }
}

