//
//  GetFilteredProductsRequestTests.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 27.12.2024.
//

import XCTest
@testable import eterationcase

final class GetFilteredProductsRequestTests: XCTestCase {
    func testGetFilteredProductsRequest() {
        // Arrange
        let request = GetFilteredProductsRequest(
            page: 1,
            limit: 10,
            brands: ["brand3"],
            models: ["model3"],
            sortField: "price",
            sortOption: "asc"
        )
        let mockNetworkManager = MockNetworkManager.shared

        // Act
        let expectation = XCTestExpectation(description: "Request should return mocked filtered products")
        mockNetworkManager.request(requestable: request, responseType: [ProductModel].self) { result in
            // Assert
            switch result {
            case .success(let products):
                XCTAssertEqual(products.count, 1)
                XCTAssertEqual(products[0].id, "3")
                XCTAssertEqual(products[0].name, "Filtered Product 1")
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
