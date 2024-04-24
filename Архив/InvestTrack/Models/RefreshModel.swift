//
//  RefreshModel.swift
//  InvestTrack
//
//  Created by Соня on 28.03.2024.
//

import Foundation

struct TokenResponse: Codable {
    let userId: Int
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

