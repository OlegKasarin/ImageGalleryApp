//
//  ImageGalleryAssembly.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import Foundation
import UIKit

struct ImageGalleryAssembly {
    static func imageGalleryViewController() -> UIViewController {
        let controller = ImageGalleryViewController()
        
        let router = ImageGalleryRouter(viewController: controller)
        
        let presenter = ImageGalleryPresenter(
            controller: controller,
            router: router,
            listPhotosService: ServiceAssembly.listPhotosService
        )
        presenter.controller = controller
        
        controller.presenter = presenter
        
        return UINavigationController(rootViewController: controller)
    }
}
