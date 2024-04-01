//
//  Double.swift
//  InvestTrack
//
//  Created by Соня on 07.03.2024.
//

import Foundation

extension Double {
    
    /// converts double to form  of 2-6 d.p
    /// 
    ///
    ///
    private var currencyFormatter2: NumberFormatter {
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //formatter.locale = .current // дефолт значение
        //formatter.currencyCode = "usd" // сменить валюту
        formatter.currencySymbol = "₽"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func asCurrencyWit2hDecimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number ) ?? ""
    }
    
    
    private var currencyFormatter6: NumberFormatter {
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //formatter.locale = .current // дефолт значение
        //formatter.currencyCode = "usd" // сменить валюту
        formatter.currencySymbol = "₽"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    func asCurrencyWit6hDecimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number ) ?? ""
    }
    
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
}
