//
//  PersistenceStorageServiceSpy.swift
//  ImageGalleryAppTests
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import Foundation
@testable import ImageGalleryApp

final class PersistenceStorageServiceSpy: PersistenceStorageServiceProtocol {
    var invokedSave = false
    var invokedSaveCount = 0
    
    var invokedGetPhotos = false
    var invokedGetPhotosCount = 0
    var stubbedGetPhotosResult: Set<Photo>
    
    var invokedRemove = false
    var invokedRemoveCount = 0
    var stubbedRemoveResult: Bool!
    
    init(stubbedGetPhotosResult: Set<Photo>) {
        self.stubbedGetPhotosResult = stubbedGetPhotosResult
    }
    
    func save(photo: Photo) {
        invokedSave = true
        invokedSaveCount += 1
    }
    
    func getPhotos() -> Set<Photo> {
        invokedGetPhotos = true
        invokedGetPhotosCount += 1
        return stubbedGetPhotosResult
    }
    
    func remove(photo: Photo) -> Bool {
        invokedRemove = true
        invokedRemoveCount += 1
        return stubbedRemoveResult
    }
}
