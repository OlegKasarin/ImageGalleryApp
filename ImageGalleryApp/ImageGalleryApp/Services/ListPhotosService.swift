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
    
    private var favoritePhotos: Set<Photo> = []
    
    private let executor: RequestExecutorProtocol
    private let storageService: PersistenceStorageServiceProtocol
    
    init(
        executor: RequestExecutorProtocol,
        storageService: PersistenceStorageServiceProtocol
    ) {
        self.executor = executor
        self.storageService = storageService
        self.favoritePhotos = storageService.getPhotos()
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
}

// MARK: - Private

private extension ListPhotosService {
    func fetch(page: Int) async throws -> [Photo] {
        let request = ListPhotosHTTPRequest(page: page, perPage: perPageCount)
        
        do {
            let response: [PhotoResponse] = try await executor.execute(request: request)
            let photos = handle(response: response)
            currentPage += 1
            isLoading = false
            return photos
        } catch {
            isLoading = false
            return try handle(error: error)
        }
    }
    
    func handle(response: [PhotoResponse]) -> [Photo] {
        response.compactMap { resp -> Photo? in
            guard let photo = Photo(response: resp) else {
                return nil
            }
            
            return favoritePhotos.contains(photo)
                ? photo.set(isFavorite: true)
                : photo
        }
    }
    
    func handle(error: Error) throws -> [Photo] {
        guard let networkError = error as? NetworkError else {
            throw error
        }
        
        switch networkError {
        case .offline:
            return Array(favoritePhotos)
        case .badResponse, .parsingError, .unknown:
            throw error
        }
    }
}
