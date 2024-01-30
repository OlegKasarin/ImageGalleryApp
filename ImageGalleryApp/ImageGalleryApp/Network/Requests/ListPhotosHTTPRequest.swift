//
//  ListPhotosHTTPRequest.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import Foundation

struct ListPhotosHTTPRequest: HTTPRequest {
    let page: Int
    let perPage: Int
    
    // MARK: - HTTPRequest
    
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
    
    var queryVariables: HTTPURLVariables? {
        var query: HTTPURLVariables = [:]
        query["page"] = String(page)
        query["per_page"] = String(perPage)
        return query
    }
    
    var headers: HTTPHeaders? {
        NetworkAPI.jsonRequestHeaders
    }
    
    var bodyPayload: HTTPBody? {
        nil
    }
}
