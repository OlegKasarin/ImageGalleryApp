//
//  ImageGalleryCellItem.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import Foundation

final class ImageGalleryCellItem {
    let id: String
    let description: String
    let imageThumbURL: String
    let imageRegularURL: String?
    var isFavorite: Bool
    
    init(
        id: String,
        description: String,
        imageThumbURL: String,
        imageRegularURL: String?,
        isFavorite: Bool
    ) {
        self.id = id
        self.description = description
        self.imageThumbURL = imageThumbURL
        self.imageRegularURL = imageRegularURL
        self.isFavorite = isFavorite
    }
}

extension ImageGalleryCellItem {
    convenience init(photo: Photo) {
        self.init(
            id: photo.id,
            description: photo.description,
            imageThumbURL: photo.thumbURL,
            imageRegularURL: photo.regularURL,
            isFavorite: photo.isFavorite
        )
    }
    
    var photo: Photo {
        Photo(
            id: id, 
            description: description,
            thumbURL: imageThumbURL,
            regularURL: imageRegularURL,
            isFavorite: isFavorite
        )
    }
}
