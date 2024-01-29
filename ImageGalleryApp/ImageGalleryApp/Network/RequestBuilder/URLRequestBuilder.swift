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

final class URLRequestBuilder: URLRequestBuilderProtocol {
    enum URLRequestBuilderError: Error {
        case invalidBaseURL
        case invalidURLParameters
        case invalidBodyPayload
    }
    
    private let baseURLString = "https://api.unsplash.com/"
    
    func buildThrows(request: HTTPRequest) throws -> URLRequest {
        do {
            let url = try buildURL(request: request)
            return try buildURLRequest(url: url, request: request)
        } catch {
            throw error
        }
    }
}

// MARK: - Private API

private extension URLRequestBuilder {
    func buildURL(request: HTTPRequest) throws -> URL {
        guard let baseURL = URL(string: baseURLString) else {
            throw URLRequestBuilderError.invalidBaseURL
        }
        
        do {
            let url = try buildURL(baseURL: baseURL, request: request)
            return url
        } catch let error {
            throw error
        }
    }
    
    func buildURL(baseURL: URL, request: HTTPRequest) throws -> URL {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw URLRequestBuilderError.invalidBaseURL
        }
        
        components.path += request.path.rawValue
        
        guard let url = components.url else {
            throw URLRequestBuilderError.invalidURLParameters
        }
        
        return url
    }
    
    func buildURLRequest(url: URL, request: HTTPRequest) throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        do {
            let body = try buildBody(request: request)
            urlRequest.httpBody = body
        } catch let error {
            throw error
        }
        
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
