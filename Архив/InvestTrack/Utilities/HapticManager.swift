//
//  HapticManager.swift
//  InvestTrack
//
//  Created by Соня on 15.04.2024.
//

import Foundation
import CoreHaptics
import SwiftUI

class HapticManager {
    static let shared = HapticManager()  // Синглтон для управления доступом

    private init() {}  

    func triggerImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
