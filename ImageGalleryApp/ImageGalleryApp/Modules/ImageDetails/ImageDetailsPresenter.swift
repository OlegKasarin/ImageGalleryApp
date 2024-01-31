//
//  ImageDetailsPresenter.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import Foundation

protocol ImageDetailsPresenterProtocol {
    func didTriggerViewLoad()
    func didTriggerViewIsAppearing()
    func didTriggerFavorite(id: String, isFavorite: Bool)
}

struct ImageDetailsInput {
    let items: [ImageGalleryCellItem]
    let selectedItem: Int
}

final class ImageDetailsPresenter {
    weak var controller: ImageDetailsViewControllerProtocol?
    
    private var items: [ImageGalleryCellItem]
    private let selectedItem: Int
    
    private let storageManager: PersistanceStorageManagerProtocol
    
    init(
        controller: ImageDetailsViewControllerProtocol,
        input: ImageDetailsInput,
        storageManager: PersistanceStorageManagerProtocol
    ) {
        self.controller = controller
        self.items = input.items
        self.selectedItem = input.selectedItem
        self.storageManager = storageManager
    }
}

// MARK: - ImageDetailsPresenterProtocol

extension ImageDetailsPresenter: ImageDetailsPresenterProtocol {
    func didTriggerViewLoad() {
        controller?.setup(items: items)
    }
    
    func didTriggerViewIsAppearing() {
        controller?.setup(selectedIndex: selectedItem)
    }
    
    func didTriggerFavorite(id: String, isFavorite: Bool) {
        guard let item = items.first(where: { $0.id == id }) else {
            return
        }
        
        item.isFavorite = isFavorite
        controller?.setup(items: items)
        
        if isFavorite {
            // save Photo to favorites
            storageManager.save(photo: item.photo)
        } else {
            // remove Photo from favorites
            do {
                try storageManager.remove(photo: item.photo)
            } catch {
                debugPrint(error)
            }
        }
    }
}
