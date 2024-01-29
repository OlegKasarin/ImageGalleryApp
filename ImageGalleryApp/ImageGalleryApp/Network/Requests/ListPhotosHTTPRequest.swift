//
//  ListPhotosHTTPRequest.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import Foundation

struct ListPhotosHTTPRequest: HTTPRequest {
    var method: HTTPRequestMethod {
        .get
    }
    
    var baseURL: String {
        ""
    }
    
    var path: HTTPPath {
        .photos
    }
    
    var isAuthorized: Bool {
        true
    }
    
    var headers: HTTPHeaders? {
        NetworkAPI.jsonRequestHeaders
    }
    
    var bodyPayload: HTTPBody? {
        nil
    }
}
