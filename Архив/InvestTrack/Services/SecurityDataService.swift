//
//  SecurityDataService.swift
//  InvestTrack
//
//  Created by Соня on 09.03.2024.
//

import Foundation
import Combine

class SecurityDataService {
    
    @Published var allSecurities: [SecurityModel] = []
    var securitySubscription: AnyCancellable?
    
    init() {
        getSecurities()
    }
    
    private func getSecurities() {
        // прочитать accessToken
        guard let accessToken = KeychainManager.shared.readAccessToken() else {
            // пробуем обновить токен
            refreshAccessToken { [weak self] success in
                if success {
                    print("AccessToken successfully refreshed. Getting securities.")
                    self?.getSecurities()
                } else {
                    print("Failed to refresh access token.")
                }
            }
            return
        }
        
        // Запрос к API
        guard let url = URL(string: "https://investtrack.nasavasa.ru/securities?access_token=\(accessToken)") else {
            print("Invalid URL")
            return
        }
        
        securitySubscription = NetworkingManager.download(url: url)
            .decode(type: SecuritiesResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedSecuritiesResponse in
                print("got data")
                self?.allSecurities = returnedSecuritiesResponse.data.securities
                self?.securitySubscription?.cancel()
            })
    }
    
    
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = KeychainManager.shared.readRefreshToken() else {
            completion(false)
            return
        }
        
        // обновление accessToken с refreshToken
        guard let refreshTokenURL = URL(string: "https://investtrack.nasavasa.ru/oauth2/refresh") else { return }
        
        // структура запроса обновления
        var request = URLRequest(url: refreshTokenURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["refresh_token": refreshToken]
        request.httpBody = try? JSONEncoder().encode(body)
        
        securitySubscription = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: TokenResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] tokenResponse in
                // Сохраняем
                KeychainManager.shared.saveAccessToken(tokenResponse.accessToken)
                KeychainManager.shared.saveRefreshToken(tokenResponse.refreshToken)
                completion(true)
            })
    }
    
    func reloadSecurities() {
        getSecurities()
    }
    
}
