//
//  PortfolioViewModel.swift
//  InvestTrack
//
//  Created by Соня on 22.04.2024.
//

import Foundation
import Combine

class PortfolioViewModel: ObservableObject {
    // Сервис для работы с портфелем
    private let portfolioService: PortfolioService
    // Подписки для отслеживания асинхронных операций
    private var cancellables = Set<AnyCancellable>()
    
    @Published var securitiesInPortfolio: [SecurityModel] = [] 
    @Published var isLoading = false // Индикатор загрузки данных

    @Published var securityId: String = ""
    @Published var boardId: String = ""
    @Published var amount: Int = 0

    init(portfolioService: PortfolioService) {
        self.portfolioService = portfolioService
    }
    
    func savePortfolio() {
        guard let accessToken = KeychainManager.shared.readAccessToken() else { return }
        
        let request = PortfolioRequest(
            access_token: accessToken,
            security_id: securityId,
            board_id: boardId,
            amount: amount
        )

        portfolioService.savePortfolio(request)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] response in
                // Обработка успешного сохранения данных.
                print("Portfolio data saved: \(response.description)")
                // Вызовите здесь обновление UI через @Published свойства или отправку уведомления
            })
            .store(in: &cancellables)
    }
    
    func loadPortfolio() {
        guard let accessToken = KeychainManager.shared.readAccessToken() else { return }
        portfolioService.fetchPortfolio()
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] response in
                print(">>>Portfolio data loaded: \(response.data)")
                self?.securitiesInPortfolio = response.data.securities.map { SecurityModel(from: $0) }
            })
            .store(in: &cancellables)
    }
    
    
    // Дополнительные методы для обновления securityId, boardId и amount
    func updateSecurityId(_ newId: String) {
        securityId = newId
    }
    
    func updateBoardId(_ newId: String) {
        boardId = newId
    }
    
    func updateAmount(_ newAmount: Int) {
        amount = newAmount
    }
}
