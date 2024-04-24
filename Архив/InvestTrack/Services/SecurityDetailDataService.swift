//
//  SecurityDetailDataService.swift
//  InvestTrack
//
//  Created by Соня on 18.04.2024.
//



import Foundation
import Combine

class SecurityDetailDataService {
    @Published var securityDetails: SecuritiesDetailResponse?
    @Published var historyData: [SecurityHistory] = [] // Добавлено для истории торгов
    private let baseURLString = "https://investtrack.nasavasa.ru/securities/"
    private let accessToken = "8x7xX1VmkuzDrOw8sW6e5g5ERe4nQ3Z1"
    private var cancellables = Set<AnyCancellable>()
    
    func createSecuritiesURL(securityId: String, boardId: String, analytics: Bool) -> URL? {
        var components = URLComponents(string: baseURLString + securityId)
        components?.queryItems = [
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "board_id", value: boardId),
            URLQueryItem(name: "analytics", value: String(analytics))
        ]
        
        print("Formed URL: \(String(describing: components?.url))")
        return components?.url
    }
    
    func fetchSecurityDetails(securityId: String,
                              boardId: String,
                              analytics: Bool,
                              completion: @escaping (Result<SecuritiesDetailResponse, Error>) -> Void) {
        
        guard let url = createSecuritiesURL(securityId: securityId, 
                                            boardId: boardId,
                                            analytics: analytics) else {
            completion(.failure(NetworkingManager.NetworkingError.badURLResponse(url: URL(string: baseURLString)!, statusCode: 400)))
            return
        }
        
        NetworkingManager.download(url: url)
            .decode(type: SecuritiesDetailResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to decode:", error)
                    if let decodingError = error as? DecodingError {
                        self.handleDecodingError(decodingError)
                    }
                    completion(.failure(error))
                }
            }, receiveValue: { [weak self] response in
                //                print("Decoded data: \(response)") // отладочный
                self?.securityDetails = response
                self?.historyData = response.data.security.history
                completion(.success(response))
            })
            .store(in: &cancellables)
    }
    
    private func handleDecodingError(_ error: DecodingError) {
        switch error {
        case .typeMismatch(let type, let context):
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("Coding Path:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
        case .valueNotFound(let type, let context):
            print("Value '\(type)' not found:", context.debugDescription)
            print("Coding Path:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
        case .keyNotFound(let key, let context):
            print("Key '\(key.stringValue)' not found:", context.debugDescription)
            print("Coding Path:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
        case .dataCorrupted(let context):
            print("Data corrupted:", context.debugDescription)
            print("Coding Path:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
        @unknown default:
            print("Unknown decoding error")
        }
    }
}
