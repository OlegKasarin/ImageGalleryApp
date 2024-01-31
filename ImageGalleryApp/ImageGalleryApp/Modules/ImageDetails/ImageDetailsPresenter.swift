//
//  ImageDetailsPresenter.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import Foundation

protocol ImageDetailsPresenterProtocol {
    
}

struct ImageDetailsInput {
    let items: [ImageGalleryCellItem]
    let selectedItem: Int
}

final class ImageDetailsPresenter {
    private let input: ImageDetailsInput
    
    init(input: ImageDetailsInput) {
        self.input = input
    }
}

// MARK: - ImageDetailsPresenterProtocol

extension ImageDetailsPresenter: ImageDetailsPresenterProtocol {
    
}
