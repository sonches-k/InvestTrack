//
//  HomeViewModel.swift
//  InvestTrack
//
//  Created by Соня on 08.03.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allSecurities: [SecurityModel] = []
    @Published var portfolioSecurities: [SecurityModel] = []
    @Published var searchText: String = ""
    
    private let dataService = SecurityDataService()
    private var cancellables = Set<AnyCancellable>()
    
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
            .combineLatest(dataService.$allSecurities)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterSecurities)
            .sink { [weak self] (returnedSecurities) in
                self?.allSecurities = returnedSecurities
            }
            .store(in: &cancellables)
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
}
