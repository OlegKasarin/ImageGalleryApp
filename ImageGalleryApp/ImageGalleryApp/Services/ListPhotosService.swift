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
    private var favoritePhotos: Set<Photo> = []
    
    private let executor: RequestExecutorProtocol
    private let storageManager: PersistanceStorageManagerProtocol
    
    init(
        executor: RequestExecutorProtocol,
        storageManager: PersistanceStorageManagerProtocol
    ) {
        self.executor = executor
        self.storageManager = storageManager
        
        do {
            self.favoritePhotos = try storageManager.getPhotos()
        } catch {
            self.favoritePhotos = []
        }
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
            let responses: [PhotoResponse] = try await executor.execute(request: request)
            
            let photos: [Photo] = responses.compactMap { response -> Photo? in
                guard let photo = Photo(response: response) else {
                    return nil
                }
                
                return favoritePhotos.contains(photo)
                    ? photo.set(isFavorite: true)
                    : photo
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
            return try handle(result: [], error: error)
        }
    }
    
    private func handle(result: [Photo], error: Error) throws -> [Photo] {
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
