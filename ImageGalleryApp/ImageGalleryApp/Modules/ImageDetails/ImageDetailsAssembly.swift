//
//  ImageDetailsAssembly.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import Foundation
import UIKit

struct ImageDetailsAssembly {
    static func imageDetailsViewController(
        input: ImageDetailsInput
    ) -> UIViewController {
        let controller = UIViewController()
        
        let presenter = ImageDetailsPresenter(input: input)
        
        return controller
    }
}
