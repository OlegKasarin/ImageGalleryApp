//
//  Photo.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import Foundation

struct Photo {
    let id: String
    let description: String
    let thumbURL: String
    let regularURL: String?
    let isFavorite: Bool
}

extension Photo: Hashable {
     static func == (lhs: Photo, rhs: Photo) -> Bool {
         lhs.id == rhs.id
         && lhs.description == rhs.description
         && lhs.thumbURL == rhs.thumbURL
         && lhs.regularURL == rhs.regularURL
     }

     func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }
}

extension Photo {
    func set(isFavorite: Bool) -> Self {
        Self(
            id: self.id,
            description: self.description,
            thumbURL: self.thumbURL,
            regularURL: self.regularURL,
            isFavorite: isFavorite
        )
    }
}

extension Photo {
    
    // MARK: - Init with DTO object
    
    init?(response: PhotoResponse) {
        guard let id = response.id, let thumb = response.urls.thumb else {
            return nil
        }
        self.id = id
        description = response.description ?? ""
        thumbURL = thumb
        regularURL = response.urls.regular
        isFavorite = false
    }
    
    // MARK: - Init with DB object
    
    init?(model: PhotoModel) {
        guard let id = model.photoID, let thumb = model.photoThumbURL else {
            return nil
        }
        self.id = id
        description = model.photoDescription ?? ""
        thumbURL = thumb
        regularURL = model.photoRegularURL
        self.isFavorite = model.photoIsFavorite
    }
}
