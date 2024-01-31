//
//  PersistanceStorageManagerSpy.swift
//  ImageGalleryAppTests
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import Foundation
@testable import ImageGalleryApp

final class PersistanceStorageManagerSpy: PersistanceStorageManagerProtocol {
    var invokedSave = false
    var invokedSaveCount = 0
    
    var invokedGetPhotos = false
    var invokedGetPhotosCount = 0
    var stubbedGetPhotosError: Error?
    var stubbedGetPhotosResult: Set<Photo>
    
    var invokedRemove = false
    var invokedRemoveCount = 0
    var stubbedRemoveError: Error?
    
    init(stubbedGetPhotosResult: Set<Photo>) {
        self.stubbedGetPhotosResult = stubbedGetPhotosResult
    }
    
    func save(photo: Photo) {
        invokedSave = true
        invokedSaveCount += 1
    }
    
    func getPhotos() throws -> Set<Photo> {
        invokedGetPhotos = true
        invokedGetPhotosCount += 1
        if let error = stubbedGetPhotosError {
            throw error
        }
        return stubbedGetPhotosResult
    }
    
    func remove(photo: Photo) throws {
        invokedRemove = true
        invokedRemoveCount += 1
        if let error = stubbedRemoveError {
            throw error
        }
    }
}
