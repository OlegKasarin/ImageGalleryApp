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
        
    }
}
