//
//  ListPhotosServiceTests.swift
//  ImageGalleryAppTests
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import XCTest
@testable import ImageGalleryApp

final class ListPhotosServiceTests: XCTestCase {
    private var sut: ListPhotosServiceProtocol!
    
    private var requestExecutorSpy: RequestExecutorSpy!
    private var storageServiceSpy: PersistenceStorageServiceSpy!
    
    override func setUpWithError() throws {
        requestExecutorSpy = RequestExecutorSpy()
        storageServiceSpy = PersistenceStorageServiceSpy(
            stubbedGetPhotosResult: mockPhotoResult
        )
        sut = ListPhotosService(
            executor: requestExecutorSpy,
            storageService: storageServiceSpy
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        requestExecutorSpy = nil
        storageServiceSpy = nil
    }

    func testFetchSuccess() async throws {
        
        requestExecutorSpy.stubbedExecuteRequestTResult = [mockPhotoResponse1, mockPhotoResponse2]
        
        let result = try await sut.fetch()
        
        XCTAssertFalse(result.isEmpty, "Expected non empty array of Photos")
        
        XCTAssertTrue(requestExecutorSpy.invokedExecuteRequestT)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestTCount, 1)
        
        XCTAssertTrue(storageServiceSpy.invokedGetPhotos)
        XCTAssertEqual(storageServiceSpy.invokedGetPhotosCount, 1)
        
        let favoritePhoto = result.first(where: { $0.isFavorite })!
        XCTAssertEqual(favoritePhoto.id, "2")
    }
    
    func testFetchFailure() async throws {
        requestExecutorSpy.stubbedExecuteRequestTError = "Error"
        
        do {
            let _ = try await sut.fetch()
        } catch {
            XCTAssertNotNil(error)
        }
        
        XCTAssertTrue(requestExecutorSpy.invokedExecuteRequestT)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestTCount, 1)
    }
}

private let mockPhotoResponse1 = PhotoResponse(
    id: "1",
    description: "description",
    urls: PhotoURLsResponse(thumb: "thumbURL", regular: nil)
)
private let mockPhotoResponse2 = PhotoResponse(
    id: "2",
    description: "description",
    urls: PhotoURLsResponse(thumb: "thumbURL", regular: nil)
)

private let mockPhotoResult: Set<Photo> = [
    Photo(
        id: "2",
        description: "description",
        thumbURL: "thumbURL",
        regularURL: nil,
        isFavorite: true
    )
]
