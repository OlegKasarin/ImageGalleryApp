//
//  NetworkAssembly.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 29/01/2024.
//

import Foundation

struct NetworkAssembly {
    static var requestExecutor: RequestExecutorProtocol {
        HTTPRequestExecutor(builder: URLRequestBuilder())
    }
}
