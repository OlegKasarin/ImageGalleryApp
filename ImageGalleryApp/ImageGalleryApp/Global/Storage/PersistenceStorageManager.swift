//
//  PersistenceStorageManager.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import Foundation
import CoreData
import UIKit

protocol PersistenceStorageManagerProtocol {
    var context: NSManagedObjectContext { get }
    
    func save(object: NSManagedObject)
    func retrieveObjects<T: NSManagedObject>(type: T.Type) throws -> [T]
    func deleteObject<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?) throws
}

final class PersistenceStorageManager {
    private let containerName = "PhotoModelStorage"
    
    static let shared: PersistenceStorageManagerProtocol = PersistenceStorageManager()
    
    private init() {}
    
    var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.main.url(forResource: containerName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        let container = NSPersistentContainer(name: containerName, managedObjectModel: managedObjectModel)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                persistentContainer.viewContext.rollback()
            }
        }
    }
}

// MARK: - PersistanceStorageManagerProtocol

extension PersistenceStorageManager: PersistenceStorageManagerProtocol {
    func save(object: NSManagedObject) {
        saveContext()
    }
    
    func retrieveObjects<T: NSManagedObject>(type: T.Type) throws -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            throw "Core Data: Get - error while fetching models"
        }
    }
    
    func deleteObject<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil) throws {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request)
            
            if let object = result.first {
                context.delete(object)
                saveContext()
            }
        } catch {
            throw "Core Data: Remove - error while fetching models"
        }
    }
}
