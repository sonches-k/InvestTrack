//
//  RegistrationService.swift
//  InvestTrack
//
//  Created by Соня on 27.03.2024.
//
import Foundation

class RegistrationService {
    
    func register(user: RegistrationRequest, completion: @escaping (Result<UserData, Error>) -> Void) {
        let url = URL(string: "https://investtrack.nasavasa.ru/oauth2/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    let error = error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown network error"])
                    completion(.failure(error))
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let responseData = try decoder.decode(RegistrationResponse.self, from: data)
                    
                    // код ошибки
                    if let errorCode = responseData.errorCode {
                        let error = NSError(domain: "RegistrationError", code: errorCode, userInfo: [NSLocalizedDescriptionKey: responseData.description])
                        completion(.failure(error))
                        return
                    }
                    
                    //  данные пользователя существуют?)))
                    guard let userData = responseData.data else {
                        let error = NSError(domain: "RegistrationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User data is missing"])
                        completion(.failure(error))
                        return
                    }
                    
                    // Сохраняем токены в Keychain и выводим
                    self.saveTokensToKeychain(accessToken: userData.accessToken, refreshToken: userData.refreshToken)
                    
                    // Все хорошо, возвращаем данные пользователя
                    completion(.success(userData))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    private func saveTokensToKeychain(accessToken: String, refreshToken: String) {
        //  в Data и сохранение в Keychain
        if let accessTokenData = accessToken.data(using: .utf8),
           let refreshTokenData = refreshToken.data(using: .utf8) {
            KeychainManager.shared.save(accessTokenData, for: "accessToken")
            KeychainManager.shared.save(refreshTokenData, for: "refreshToken")
            
            //  отладка
            print("Access Token: \(accessToken)")
            print("Refresh Token: \(refreshToken)")
        }
    }
}
