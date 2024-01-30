//
//  ImageGalleryRouter.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import Foundation

protocol ImageGalleryRouterProtocol {
    
}

final class ImageGalleryRouter {
    weak var viewController: ImageGalleryViewControllerProtocol?
    
    init(viewController: ImageGalleryViewControllerProtocol) {
        self.viewController = viewController
    }
}

// MARK: - ImageGalleryRouterProtocol

extension ImageGalleryRouter: ImageGalleryRouterProtocol {
    
}
