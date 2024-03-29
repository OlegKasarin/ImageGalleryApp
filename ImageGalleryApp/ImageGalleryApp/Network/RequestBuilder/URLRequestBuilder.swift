//
//  URLRequestBuilder.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 29/01/2024.
//

import Foundation

protocol URLRequestBuilderProtocol {
    func buildThrows(request: HTTPRequest) throws -> URLRequest
}

final class URLRequestBuilder {
    private let baseURLString = "https://api.unsplash.com"
    
    enum URLRequestBuilderError: Error {
        case invalidBaseURL
        case invalidURLParameters
        case invalidBodyPayload
    }
}

// MARK: - URLRequestBuilderProtocol

extension URLRequestBuilder: URLRequestBuilderProtocol {
    func buildThrows(request: HTTPRequest) throws -> URLRequest {
        do {
            let url = try buildURL(request: request)
            return try buildURLRequest(url: url, request: request)
        } catch {
            throw error
        }
    }
}

// MARK: - Private

private extension URLRequestBuilder {
    func buildURL(request: HTTPRequest) throws -> URL {
        guard let baseURL = URL(string: baseURLString) else {
            throw URLRequestBuilderError.invalidBaseURL
        }
        
        return try buildURL(baseURL: baseURL, request: request)
    }
    
    func buildURL(baseURL: URL, request: HTTPRequest) throws -> URL {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw URLRequestBuilderError.invalidBaseURL
        }
        
        components.path += request.path.rawValue
        
        if let queryItems = buildQueryItems(request: request) {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw URLRequestBuilderError.invalidURLParameters
        }
        
        return url
    }
    
    func buildQueryItems(request: HTTPRequest) -> [URLQueryItem]? {
        guard let variables = request.queryVariables else {
            return nil
        }
        
        var queryItems: [URLQueryItem] = []
        for (key, value) in variables {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        return queryItems
    }
    
    func buildURLRequest(url: URL, request: HTTPRequest) throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        let body = try buildBody(request: request)
        urlRequest.httpBody = body
        
        urlRequest = addHeaders(from: request, to: urlRequest)
        
        return urlRequest
    }
    
    func buildBody(request: HTTPRequest) throws -> Data? {
        var body: HTTPBody = [:]
        
        if let payload = request.bodyPayload {
            body = body.merging(payload, uniquingKeysWith: { (current, _) in current })
        }
        
        if body.isEmpty {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            return data
        } catch {
            throw URLRequestBuilderError.invalidBodyPayload
        }
    }
    
    func addHeaders(from request: HTTPRequest, to urlRequest: URLRequest) -> URLRequest {
        guard let headers = request.headers else {
            return urlRequest
        }
        
        var updatedURLRequest = urlRequest
        
        if request.isAuthorized {
            let value = "Client-ID " + NetworkAPI.clientId
            updatedURLRequest.setValue(value, forHTTPHeaderField: "Authorization")
        }
        
        for (key, value) in headers {
            updatedURLRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return updatedURLRequest
    }
}
