//
//  ServiceAssembly.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import Foundation

struct ServiceAssembly {
    static var listPhotosService: ListPhotosServiceProtocol {
        ListPhotosService(
            executor: NetworkAssembly.requestExecutor,
            storageService: persistenceStorageService
        )
    }
    
    static var persistenceStorageService: PersistenceStorageServiceProtocol {
        PersistenceStorageService(persistenceManager: PersistenceStorageManager.shared)
    }
}
