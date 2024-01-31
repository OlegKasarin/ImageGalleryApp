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
}

extension Photo {
    init?(response: PhotoResponse) {
        guard let id = response.id, let thumb = response.urls.thumb else {
            return nil
        }
        self.id = id
        description = response.description ?? ""
        thumbURL = thumb
        regularURL = response.urls.regular
    }
}
