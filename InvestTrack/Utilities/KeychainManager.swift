//
//  KeychainManager.swift
//  InvestTrack
//
//  Created by Соня on 28.03.2024.
//

import Foundation
import Security

class KeychainManager {
    
    static let shared = KeychainManager()
    
    func save(_ data: Data, for key: String) {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary) // Удалить старое значение, если оно существует
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return print("Error: \(status)") }
    }
    
    func read(for key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
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
}

