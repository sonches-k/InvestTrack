//
//  RegistrationModel.swift
//  InvestTrack
//
//  Created by Соня on 27.03.2024.
//

import Foundation

struct RegistrationRequest: Codable {
    let nickname: String
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case nickname, email, password
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct RegistrationResponse: Codable {
    let data: UserData?
    let description: String
    let errorCode: Int?

    enum CodingKeys: String, CodingKey {
        case data
        case description
        case errorCode = "error_code"
    }
}

struct UserData: Codable {
    let userId: Int
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

