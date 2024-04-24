//
//  NetworkingManager.swift
//  InvestTrack
//
//  Created by Соня on 09.03.2024.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL, statusCode: Int)
        case serverError(code: ErrorCode, description: String)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url, statusCode: let statusCode):
                return "[🔥] Bad response from URL: \(url) with status code: \(statusCode)"
            case .serverError(code: let code, description: let description):
                return "[🚨] Server Error \(code): \(description)"
            case .unknown:
                return "[⚠️] Unknown error occurred"
            }
        }
    }
    
    enum ErrorCode: Int, Codable {
        case unknown = 0
        case invalidInputData = 1
        case accessTokenExpired = 2
        case refreshTokenExpired = 3
        case moexApiNoData = 4
        case moexApiError = 5
    }

    static func createRequest(url: URL, method: String, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body = body {
            request.httpBody = body
        }
        if let accessToken = KeychainManager.shared.readAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    static func request(url: URL, method: String = "GET", body: Data? = nil) -> AnyPublisher<Data, Error> {
        let request = createRequest(url: url, method: method, body: body)
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return request(url: url)
    }

    static func post(url: URL, body: Data) -> AnyPublisher<Data, Error> {
        return request(url: url, method: "POST", body: body)
    }

    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkingError.unknown
        }
        
        if [200, 201].contains(response.statusCode) {
            return output.data
        } else {
            do {
                let errorData = try JSONDecoder().decode(ServerErrorResponse.self, from: output.data)
                let errorCode = ErrorCode(rawValue: errorData.errorCode) ?? .unknown
                throw NetworkingError.serverError(code: errorCode, description: errorData.description)
            } catch {
                let rawResponse = String(data: output.data, encoding: .utf8) ?? "Не могу декодировать данные"
                print("Ошибка декодирования: \(error). Ответ сервера: \(rawResponse)")
                throw NetworkingError.unknown
            }
        }
    }

    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("Запрос успешно завершен")
        case .failure(let error):
            print("Ошибка: \(error.localizedDescription)")
        }
    }

    static func fetchWithTokenRefresh(url: URL) -> AnyPublisher<Data, Error> {
        download(url: url)
            .catch { error -> AnyPublisher<Data, Error> in
                guard let networkingError = error as? NetworkingError,
                      case .serverError(let code, _) = networkingError,
                      (code == .accessTokenExpired || code == .refreshTokenExpired) else {
                          return Fail(error: error).eraseToAnyPublisher()
                      }

                return KeychainManager.shared.refreshToken()
                    .flatMap { success -> AnyPublisher<Data, Error> in
                        guard success else {
                            return Fail(error: NetworkingError.unknown).eraseToAnyPublisher()
                        }
                        return download(url: url)
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
}

// Декодирование ответа сервера при ошибке
struct ServerErrorResponse: Codable {
    let errorCode: Int
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case description
    }
}





