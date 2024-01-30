//
//  ImageGalleryPresenter.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import Foundation

protocol ImageGalleryPresenterProtocol {
    func didTriggerViewLoad()
}

final class ImageGalleryPresenter {
    weak var controller: ImageGalleryViewControllerProtocol?
    
    private let router: ImageGalleryRouterProtocol
    private let listPhotosService: ListPhotosServiceProtocol
    
    private var items: [ImageGalleryCellItem] = []
    
    init(
        controller: ImageGalleryViewControllerProtocol,
        router: ImageGalleryRouterProtocol,
        listPhotosService: ListPhotosServiceProtocol
    ) {
        self.controller = controller
        self.router = router
        self.listPhotosService = listPhotosService
    }
}

// MARK: - ImageGalleryPresenterProtocol

extension ImageGalleryPresenter: ImageGalleryPresenterProtocol {
    func didTriggerViewLoad() {
        fetch()
    }
}

// MARK: - Private

private extension ImageGalleryPresenter {
    func fetch() {
        Task {
            let photos = try await listPhotosService.fetch()
            let fetchedItems = photos.map {
                ImageGalleryCellItem(
                    title: $0.description,
                    description: $0.description,
                    imageURL: $0.thumbURL,
                    isFavorite: true
                )
            }
            
            items.append(contentsOf: fetchedItems)
            
            await refresh()
        }
    }
    
    @MainActor func refresh() {
        controller?.refresh(items: items)
    }
}
