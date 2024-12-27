//
//  SearchProductsRequests.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 27.12.2024.
//

import XCTest
@testable import eterationcase

final class SearchProductsRequestTests: XCTestCase {
    func testSearchProductsRequest() {
        let request = SearchProductsRequest(page: 1, limit: 10, search: "Search")
        let mockNetworkManager = MockNetworkManager.shared

        let expectation = XCTestExpectation(description: "Request should return mocked search results")
        mockNetworkManager.request(requestable: request, responseType: [ProductModel].self) { result in
            switch result {
            case .success(let products):
                XCTAssertEqual(products.count, 1)
                XCTAssertEqual(products[0].id, "4")
                XCTAssertEqual(products[0].name, "Search Product 1")
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
