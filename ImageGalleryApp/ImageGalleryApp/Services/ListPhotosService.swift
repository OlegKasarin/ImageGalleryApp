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
    static private let perPageCount = 30
    static private let initialPage = 1
    
    private var isFirstCall = true
    private(set) var isLoading = false
    private var currentPage = initialPage
    
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
            fetchTask?.cancel()
        }
        
        isLoading = true
        
        if isFirstCall {
            isFirstCall = false
            return try await fetch(page: ListPhotosService.initialPage)
        } else {
            return try await fetch(page: currentPage)
        }
    }
    
    func fetch(page: Int) async throws -> [Photo] {
        fetchTask = Task { () -> [Photo] in
            let request = ListPhotosHTTPRequest(
                page: page,
                perPage: ListPhotosService.perPageCount
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
