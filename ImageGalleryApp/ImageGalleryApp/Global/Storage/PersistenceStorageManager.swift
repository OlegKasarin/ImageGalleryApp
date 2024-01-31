//
//  PersistenceStorageManager.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import Foundation
import CoreData
import UIKit

protocol PersistanceStorageManagerProtocol {
    func save(photo: Photo)
    func getPhotos() throws -> Set<Photo>
    func remove(photo: Photo) throws
}

final class PersistanceStorageManager {
    private let context: NSManagedObjectContext
    
    required init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unknown error")
        }

        self.context = appDelegate.persistentContainer.viewContext
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
            }
        }
    }
}

// MARK: - PersistanceStorageManagerProtocol

extension PersistanceStorageManager: PersistanceStorageManagerProtocol {
    func save(photo: Photo) {
        let photoModel = PhotoModel(context: context)
        photoModel.photoID = photo.id
        photoModel.photoDescription = photo.description
        photoModel.photoThumbURL = photo.thumbURL
        photoModel.photoRegularURL = photo.regularURL
        photoModel.photoIsFavorite = photo.isFavorite
        
        saveContext()
    }
    
    func getPhotos() throws -> Set<Photo> {
        let imageRequest: NSFetchRequest<PhotoModel> = PhotoModel.fetchRequest()
        
        do {
            let result = try context.fetch(imageRequest)
            return Set(result.compactMap { Photo(model: $0) })
        } catch {
            throw "Core Data: Get - error while fetching models"
        }
    }
    
    func remove(photo: Photo) throws {
        let imageRequest: NSFetchRequest<PhotoModel> = PhotoModel.fetchRequest()
        let predicate = NSPredicate(format: "photoID == %@", photo.id)
        imageRequest.predicate = predicate
        
        do {
            let result = try context.fetch(imageRequest)
            
            if let model = result.first {
                context.delete(model)
                saveContext()
            }
        } catch {
            throw "Core Data: Remove - error while fetching models"
        }
    }
}
