//
//  HTTPRequest.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 29/01/2024.
//

import Foundation


typealias HTTPBody = [String: Any]

enum HTTPRequestMethod: String {
    case get = "GET"
}

enum HTTPPath: String {
    case photos = "/photos"
}
