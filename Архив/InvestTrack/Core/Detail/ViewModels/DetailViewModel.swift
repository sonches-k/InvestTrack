//
//  DetailViewModel.swift
//  InvestTrack
//
//  Created by Соня on 18.04.2024.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    
    @Published var security: SecurityModel
    
    @Published var securityDetails: SecuritiesDetailResponse?
    private let securityDetailService = SecurityDetailDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(security: SecurityModel) {
        self.security = security
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        securityDetailService.$securityDetails
            .receive(on: RunLoop.main) // Переключение на главный поток
            .combineLatest($security)
            .map({ (SecurityDetailModel, securityModel) -> (overview: [StatisticModel], additional: [StatisticModel]) in
                
                let price = SecurityDetailModel?.data.security.currentPrice
                let priceChange = SecurityDetailModel?.data.security.priceChangePercentage24h
                let priceStat = StatisticModel(title: "Current Price", value: String(price ?? 0) + "₽", percentageChange: priceChange)
                let board = SecurityDetailModel?.data.security.boardId
                let boardStat = StatisticModel(title: "Board", value: board ?? "")
                let ticker = SecurityDetailModel?.data.security.securityId
                let tickerStat = StatisticModel(title: "Ticker", value: ticker ?? "")
                let overviewArray: [StatisticModel] = [
                    priceStat, boardStat, tickerStat
                ]
                
                
                let high = SecurityDetailModel?.data.security.analytics.maxPrice
                let low = SecurityDetailModel?.data.security.analytics.minPrice
                let verdict = SecurityDetailModel?.data.security.analytics.purchaseVerdict
                let highStat = StatisticModel(title: "24H high", value: String(high ?? 0))
                let lowStat = StatisticModel(title: "24H low", value: String(low ?? 0))
        
                let verdictStatValue: String
                if let verdictNumber = verdict, let verdictEnum = PurchaseVerdict(rawValue: verdictNumber) {
                    verdictStatValue = verdictEnum.description
                } else {
                    verdictStatValue = "Unknown"
                }
                
                let verdictStat = StatisticModel(title: "Purchase Verdict", value: verdictStatValue)
                
                
                let additionalArray: [StatisticModel] = [
                    highStat, lowStat, verdictStat
                ]
                return(overviewArray, additionalArray)
            })
            .sink { [weak self] (returnedArray/*returnedSecurityDetails*/) in
                //                self?.securityDetails = returnedSecurityDetails
                //                print(returnedArray.overview)
                //                print(returnedArray.additional)
                self?.overviewStatistics = returnedArray.overview
                self?.additionalStatistics = returnedArray.additional
            }
            .store(in: &cancellables)
    }
    
    // Запрос
    func fetchDetails(securityId: String, boardId: String, analytics: Bool) {
        securityDetailService.fetchSecurityDetails(securityId: securityId, boardId: boardId, analytics: analytics) { [weak self] result in
            switch result {
            case .success(let details):
                self?.securityDetails = details
            case .failure(let error):
                print("Error fetching details: \(error.localizedDescription)")
            }
        }
    }
}
