//
//  PortfolioManager.swift
//  InvestTrack
//
//  Created by Соня on 22.04.2024.
//

import Foundation
import Combine



class PortfolioService {
    private let accessToken = "8x7xX1VmkuzDrOw8sW6e5g5ERe4nQ3Z1"
    func savePortfolio(_ request: PortfolioRequest) -> AnyPublisher<PortfolioResponse, Error> {
        guard let url = URL(string: "https://investtrack.nasavasa.ru/portfolio/add") else {
            return Fail(error: NetworkingManager.NetworkingError.unknown).eraseToAnyPublisher()
        }
        
        do {
            let requestData = try JSONEncoder().encode(request)
            return NetworkingManager.post(url: url, body: requestData)
                .decode(type: PortfolioResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func fetchPortfolio() -> AnyPublisher<PortfolioResponse, Error> {
        guard let url = URL(string: "https://investtrack.nasavasa.ru/portfolio?access_token=\(accessToken)") else {
            return Fail(error: NetworkingManager.NetworkingError.unknown).eraseToAnyPublisher()
        }
        
        return NetworkingManager.fetchWithTokenRefresh(url: url)
            .decode(type: PortfolioResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
