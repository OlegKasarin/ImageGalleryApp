//
//  RequestExecutorSpy.swift
//  ImageGalleryAppTests
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import Foundation
@testable import ImageGalleryApp

final class RequestExecutorSpy: RequestExecutorProtocol {
    var invokedExecuteRequestT = false
    var invokedExecuteRequestTCount = 0
    var stubbedExecuteRequestTError: Error?
    var stubbedExecuteRequestTResult: [Any]!
    
    func execute<T: Decodable>(request: HTTPRequest) async throws -> [T] {
        invokedExecuteRequestT = true
        invokedExecuteRequestTCount += 1
        
        await Task(priority: .medium) {
          await withUnsafeContinuation { continuation in
            Thread.sleep(forTimeInterval: 1)
            continuation.resume()
          }
        }.value
        
        if let error = stubbedExecuteRequestTError {
            throw error
        }
        let result = stubbedExecuteRequestTResult as! [T]
        return result
    }
}
