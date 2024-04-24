//
//  HomeViewModel.swift
//  InvestTrack
//
//  Created by Соня on 08.03.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    private let portfolioService: PortfolioService = PortfolioService()
    
    @Published var allSecurities: [SecurityModel] = []
    @Published var portfolioSecurities: [SecurityModel] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .initial
    
    
    private let dataService = SecurityDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case  initial, initialReversed, price, priceReversed, holdings, holdingsReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        dataService.$allSecurities
            .sink { [weak self] (returnedSecurities) in
                self?.allSecurities = returnedSecurities
            }
            .store(in: &cancellables)
        
        $searchText
            .combineLatest(dataService.$allSecurities, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortSecurities)
            .sink { [weak self] (returnedSecurities) in
                self?.allSecurities = returnedSecurities
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortSecurities(text: String, securities: [SecurityModel], sort: SortOption) -> [SecurityModel] {
        let filteredSecurities = filterSecurities(text: text, securities: securities)
        let sortedSecurities = sortSecurities(sort: sort, securities: filteredSecurities)
        return sortedSecurities
    }
    
    private func filterSecurities(text: String, securities: [SecurityModel]) -> [SecurityModel] {
        guard !text.isEmpty else {
            return securities
        }
        let lowercasedText = text.lowercased()
        
        return securities.filter { (security) -> Bool in
            return security.securityId.lowercased().contains(lowercasedText) || security.name.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortSecurities(sort: SortOption, securities: [SecurityModel]) -> [SecurityModel] {
        switch sort {
        case .initial:
            return securities // Сортировка по умолчанию, как пришли данные
        case .initialReversed:
            return securities.reversed() // Обратная сортировка
        case .price, .holdings:
            return securities.sorted(by: { $0.priceChangePercentage24h < $1.priceChangePercentage24h })
        case .priceReversed, .holdingsReversed:
            return securities.sorted(by: { $0.priceChangePercentage24h > $1.priceChangePercentage24h })
        }
    }
    
    private func sortPortfolioSecuritiesIfNeeded(securities: [SecurityModel]) -> [SecurityModel] {
        switch sortOption {
        case .holdings:
            return securities.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return securities.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return securities
        }
    }
    
    func loadPortfolio() {
        guard let accessToken = KeychainManager.shared.readAccessToken() else { return }
        portfolioService.fetchPortfolio()
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] response in
                print(">>>Portfolio data loaded: \(response.data)")
                self?.portfolioSecurities = response.data.securities.map { SecurityModel(from: $0) }
            })
            .store(in: &cancellables)
    }
    
    
    func refreshSecurities() {
        dataService.reloadSecurities()
    }
    
}
