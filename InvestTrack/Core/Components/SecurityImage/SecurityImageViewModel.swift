//
//  SecurityImageViewModel.swift
//  InvestTrack
//
//  Created by Соня on 09.03.2024.
//

//import Foundation
//import SwiftUI
//import Combine
//
//class SecurityImageViewModel: ObservableObject {
//    
//    @Published var image: UIImage? = nil
//    @Published var isLoading: Bool = false
//    
//    private let security: SecurityModel
//    private let dataService: SecurityImageService
//    private var cancellables = Set<AnyCancellable>()
//    
//    init(security: SecurityModel) {
//        self.security = security
//        self.dataService = SecurityImageService(security: security)
//        self.addSubscribers()
//        self.isLoading = true
//    }
//    
//    private func addSubscribers() {
//        
//        dataService.$image
//            .sink { [weak self] (_) in
//                self?.isLoading = false
//            } receiveValue: {[weak self] (returnedImage) in
//                self?.image = returnedImage
//            }
//            .store(in: &cancellables)
//    }
//    
//}
