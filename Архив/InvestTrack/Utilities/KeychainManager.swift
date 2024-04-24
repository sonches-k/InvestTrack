//
//  KeychainManager.swift
//  InvestTrack
//
//  Created by Соня on 28.03.2024.
//

import Foundation
import Security
import Combine

class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() {} // private singletone init
    
    func save(_ data: Data, for key: String) {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]
        
        SecItemDelete(query as CFDictionary) // delete old value if it exists
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return print("Error: \(status)") }
    }
    
    func read(for key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue! as CFBoolean,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        
        return item as? Data
    }
    
    func delete(for key: String) {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - Token Management

extension KeychainManager {
    
    func isUserRegistered() -> Bool {
        if let _ = readAccessToken(), let _ = readRefreshToken() {
            return true
        } else {
            return false
        }
    }
    
    func saveAccessToken(_ token: String) {
        guard let data = token.data(using: .utf8) else { return }
        save(data, for: "accessToken")
    }
    
    func saveRefreshToken(_ token: String) {
        guard let data = token.data(using: .utf8) else { return }
        save(data, for: "refreshToken")
    }
    
    func readAccessToken() -> String? {
        guard let data = read(for: "accessToken") else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func readRefreshToken() -> String? {
        guard let data = read(for: "refreshToken") else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    public func refreshToken() -> AnyPublisher<Bool, Error> {
        guard let refreshToken = readRefreshToken() else {
            return Fail(error: NSError(domain: "com.investtrack.keychain", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No refresh token available"]))
                .eraseToAnyPublisher()
        }
        
        let url = URL(string: "https://investtrack.nasavasa.ru/oauth2/refresh")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["refresh_token": refreshToken]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw NSError(domain: "com.investtrack.network", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Failed to refresh token"])
                }
                return output.data
            }
            .decode(type: TokenResponse.self, decoder: JSONDecoder())
            .tryMap { tokenResponse in
                self.saveAccessToken(tokenResponse.accessToken)
                self.saveRefreshToken(tokenResponse.refreshToken)
                return true
            }
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}




