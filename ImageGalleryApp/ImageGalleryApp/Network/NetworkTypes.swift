//
//  HTTPRequest.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 29/01/2024.
//

import Foundation

typealias HTTPBody = [String: Any]
typealias HTTPHeaders = [String: String]
typealias HTTPURLVariables = [String: String]

struct NetworkAPI {
    static var clientId = "R9EtWSrcvPtQuKkToX2c3ijAER9tIGzSg3_1kvbwYOE"
    
    static let jsonRequestHeaders: HTTPHeaders = [
        "Accept-Version": "v1"
    ]
}

enum HTTPRequestMethod: String {
    case get = "GET"
}

enum HTTPPath: String {
    case photos = "/photos"
}

protocol HTTPRequest {
    var method: HTTPRequestMethod { get }
    var baseURL: String { get }
    var path: HTTPPath { get }
    var isAuthorized: Bool { get }
    var queryVariables: HTTPURLVariables? { get }
    var headers: HTTPHeaders? { get }
    var bodyPayload: HTTPBody? { get }
}
