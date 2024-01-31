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
    
    private var isFirstCall = true
    private(set) var isLoading = false
    private var currentPage = 1
    
    private var fetchTask: Task<[Photo], Error>?
    
    private let executor: RequestExecutorProtocol
    
    init(executor: RequestExecutorProtocol) {
        self.executor = executor
    }
}

// MARK: - ListPhotosServiceProtocol

extension ListPhotosService: ListPhotosServiceProtocol {
    func fetch() async throws -> [Photo] {
        if isLoading {
            throw CancellationError()
        }
        
        isLoading = true
        
        if isFirstCall {
            isFirstCall = false
        }
        
        return try await fetch(page: currentPage)
    }
    
    func fetch(page: Int) async throws -> [Photo] {
        fetchTask = Task { () -> [Photo] in
            let request = ListPhotosHTTPRequest(
                page: page,
                perPage: perPageCount
            )
            let response: [PhotoResponse] = try await executor.execute(request: request)
            
            let photos = response.compactMap {
                Photo(response: $0)
            }
            
            return photos
        }
        
        currentPage += 1
        do {
            let result = try await fetchTask?.value ?? []
            isLoading = false
            return result
        } catch {
            isLoading = false
            throw error
        }
    }
}
