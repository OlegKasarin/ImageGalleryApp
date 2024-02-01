//
//  PersistenceStorageService.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 01/02/2024.
//

import Foundation
import CoreData

protocol PersistenceStorageServiceProtocol {
    func save(photo: Photo)
    func getPhotos() -> Set<Photo>
    func remove(photo: Photo) -> Bool
}

final class PersistenceStorageService {
    private let persistenceManager: PersistenceStorageManagerProtocol
    
    init(persistenceManager: PersistenceStorageManagerProtocol) {
        self.persistenceManager = persistenceManager
    }
}

// MARK: - PersistenceStorageServiceProtocol

extension PersistenceStorageService: PersistenceStorageServiceProtocol {
    func save(photo: Photo) {
        let photoModel = PhotoModel(context: persistenceManager.context)
        photoModel.photoID = photo.id
        photoModel.photoDescription = photo.description
        photoModel.photoThumbURL = photo.thumbURL
        photoModel.photoRegularURL = photo.regularURL
        photoModel.photoIsFavorite = photo.isFavorite
        
        persistenceManager.save(object: photoModel)
    }
    
    func getPhotos() -> Set<Photo> {
        do {
            let result = try persistenceManager.retrieveObjects(type: PhotoModel.self)
            return Set(result.compactMap { Photo(model: $0) })
        } catch {
            debugPrint(error)
            return Set()
        }
    }
    
    func remove(photo: Photo) -> Bool {
        let predicate = NSPredicate(format: "photoID == %@", photo.id)
        
        do {
            try persistenceManager.deleteObject(type: PhotoModel.self, predicate: predicate)
            return true
        } catch {
            debugPrint(error)
            return false
        }
    }
}
