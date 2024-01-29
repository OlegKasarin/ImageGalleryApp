//
//  HTTPRequestExecutor.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 29/01/2024.
//

import Foundation

typealias URLResponsePayload = (data: Data, response: URLResponse)

protocol RequestExecutorProtocol {
    func execute<T: Codable>(request: HTTPRequest) async throws -> [T]
}

final class HTTPRequestExecutor {
    private let builder: URLRequestBuilderProtocol
    
    init(builder: URLRequestBuilderProtocol) {
        self.builder = builder
    }
}

// MARK: - RequestExecutorProtocol

extension HTTPRequestExecutor: RequestExecutorProtocol {
    func execute<T: Codable>(request: HTTPRequest) async throws -> T {
        let urlRequest = try builder.buildThrows(request: request)
        
        let payload = try await fetchData(request: urlRequest)
        guard (payload.response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "Error: bad response"
        }
        
        return try JSONDecoder().decode(T.self, from: payload.data)
    }
    
    private func fetchData(request: URLRequest) async throws -> URLResponsePayload {
        if #available(iOS 14.0.0, *) {
            return try await URLSession.shared.data(for: request)
        } else {
            return try await URLSession.shared.data(from: request)
        }
    }
}

// MARK: - Extensions

extension URLSession {
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func data(from urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
}

extension String: Error { }
