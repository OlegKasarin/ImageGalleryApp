//
//  ListPhotosResponse.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 29/01/2024.
//

import Foundation

struct PhotoResponse: Codable {
    let id: String?
    let description: String?
    let urls: PhotoURLsResponse
}

struct PhotoURLsResponse: Codable {
    let thumb: String?
}
