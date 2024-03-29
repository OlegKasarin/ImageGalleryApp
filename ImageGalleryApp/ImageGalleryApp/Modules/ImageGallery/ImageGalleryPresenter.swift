//
//  ImageGalleryPresenter.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import Foundation

protocol ImageGalleryPresenterProtocol {
    func didTriggerViewLoad()
    func didTriggerViewWillAppear()
    func didTriggerReachEndOfList()
    func didTriggerSelectItem(index: Int)
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
    
    func didTriggerViewWillAppear() {
        controller?.refresh(items: items)
    }
    
    func didTriggerReachEndOfList() {
        fetchNext()
    }
    
    func didTriggerSelectItem(index: Int) {
        let input = ImageDetailsInput(items: items, selectedItem: index)
        router.pushToDetails(input: input)
    }
}

// MARK: - Private

private extension ImageGalleryPresenter {
    func fetch() {
        controller?.showCenterActivityIndicator()
        
        Task {
            do {
                let photos = try await listPhotosService.fetch()
                let fetchedItems = photos.map {
                    ImageGalleryCellItem(photo: $0)
                }
                
                items = fetchedItems
                
                await MainActor.run {
                    controller?.refresh(items: items)
                    controller?.hideCenterActivityIndicator()
                }
            } catch {
                await MainActor.run {
                    controller?.hideCenterActivityIndicator()
                }
            }
        }
    }
    
    func fetchNext() {
        guard !listPhotosService.isLoading else {
            return
        }
        
        controller?.showBottomActivityIndicator()
        
        Task {
            do {
                let photos = try await listPhotosService.fetch()
                let fetchedItems = photos.map {
                    ImageGalleryCellItem(photo: $0)
                }
                
                items.append(contentsOf: fetchedItems)
                
                await MainActor.run {
                    controller?.append(items: fetchedItems)
                    controller?.hideBottomActivityIndicator()
                }
            } catch {
                guard !(error is CancellationError) else {
                    return
                }
                
                await MainActor.run {
                    controller?.hideBottomActivityIndicator()
                }
            }
        }
    }
}
