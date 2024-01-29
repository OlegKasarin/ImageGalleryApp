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
}

extension Photo {
    init?(response: PhotoResponse) {
        id = response.id
        description = response.description
    }
}
