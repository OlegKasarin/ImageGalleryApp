//
//  ImageGalleryPresenter.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import Foundation

protocol ImageGalleryPresenterProtocol {
    func didTriggerViewLoad()
    func didTriggerReachEndOfList()
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
    
    func didTriggerReachEndOfList() {
        fetchNext()
    }
}

// MARK: - Private

private extension ImageGalleryPresenter {
    func fetch() {
        controller?.showCenterActivityIndicator()
        
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
        controller?.hideCenterActivityIndicator()
    }
    
    func fetchNext() {
        controller?.showBottomActivityIndicator()
        
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
            
            await append(items: fetchedItems)
        }
    }
    
    @MainActor func append(items: [ImageGalleryCellItem]) {
        controller?.append(items: items)
        controller?.hideBottomActivityIndicator()
    }
}
