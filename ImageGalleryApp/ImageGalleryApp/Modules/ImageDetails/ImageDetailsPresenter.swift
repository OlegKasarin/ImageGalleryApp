//
//  ImageDetailsPresenter.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import Foundation

protocol ImageDetailsPresenterProtocol {
    func didTriggerViewLoad()
    func didTriggerViewWillAppear()
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
    
    init(
        controller: ImageDetailsViewControllerProtocol,
        input: ImageDetailsInput
    ) {
        self.controller = controller
        self.items = input.items
        self.selectedItem = input.selectedItem
    }
}

// MARK: - ImageDetailsPresenterProtocol

extension ImageDetailsPresenter: ImageDetailsPresenterProtocol {
    func didTriggerViewLoad() {
        controller?.setup(items: items)
    }
    
    func didTriggerViewWillAppear() {
        controller?.setup(selectedItem: selectedItem)
    }
    
    func didTriggerFavorite(id: String, isFavorite: Bool) {
        guard var item = items.first(where: { $0.id == id }) else {
            return
        }
        
        item.isFavorite = isFavorite
        controller?.setup(items: items)
        
        if isFavorite {
            // save id to favorites
        } else {
            // remove id from favorites
        }
    }
}
