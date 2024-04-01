//
//  Validator.swift
//  InvestTrack
//
//  Created by Соня on 27.03.2024.
//

import Foundation

class Validator {
    
    // Email validation
    static func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        return email.range(of: emailPattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    // Phone number validation
    static func isValidPhone(_ phone: String) -> Bool {
        let phonePattern = "^\\d{10}$"
        return phone.range(of: phonePattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    // Password validation
    static func isValidPassword(_ password: String) -> Bool {
        let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^\\da-zA-Z]).{8,}$"
        return password.range(of: passwordPattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    // Nickname validation
    static func isValidNickname(_ nickname: String) -> Bool {
        return nickname.count >= 3
    }
    
    // Name validation
    static func isValidName(_ name: String) -> Bool {
        let namePattern = "^[a-zA-Z\\s]{2,}$"
        return name.range(of: namePattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

