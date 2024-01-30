//
//  ListPhotosService.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 29/01/2024.
//

import Foundation

protocol ListPhotosServiceProtocol {
    var isLoading: Bool { get }
    func fetch() async throws -> [Photo]
}

final class ListPhotosService {
    private let perPageCount = 30
    
    private(set) var isLoading = false
    
    private let executor: RequestExecutorProtocol
    
    init(executor: RequestExecutorProtocol) {
        self.executor = executor
    }
}

// MARK: - ListPhotosServiceProtocol

extension ListPhotosService: ListPhotosServiceProtocol {
    func fetch() async throws -> [Photo] {
        let request = ListPhotosHTTPRequest(page: 1, perPage: perPageCount)
        
        let response: [PhotoResponse] = try await executor.execute(request: request)
        let photos = response.compactMap {
            Photo(response: $0)
        }
        
        return photos
    }
}
