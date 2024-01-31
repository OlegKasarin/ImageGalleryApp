//
//  ImageGalleryRouter.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import Foundation

protocol ImageGalleryRouterProtocol {
    func pushToDetails(input: ImageDetailsInput)
}

final class ImageGalleryRouter {
    weak var viewController: ImageGalleryViewControllerProtocol?
    
    init(viewController: ImageGalleryViewControllerProtocol) {
        self.viewController = viewController
    }
}

// MARK: - ImageGalleryRouterProtocol

extension ImageGalleryRouter: ImageGalleryRouterProtocol {
    func pushToDetails(input: ImageDetailsInput) {
        let detailsController = ImageDetailsAssembly.imageDetailsViewController(
            input: input
        )
        viewController?.viewController.navigationController?.pushViewController(
            detailsController,
            animated: true
        )
    }
}
