//
//  ProductModelTests.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 27.12.2024.
//

import XCTest
@testable import eterationcase

final class ProductModelTests: XCTestCase {
    func testProductModelDecoding() {
        // Arrange
        let jsonData = """
        { "id": "1", "name": "Product 1", "image": "url1", "price": "100", "description": "desc", "model": "model1", "brand": "brand1", "createdAt": "2024-01-01" }
        """.data(using: .utf8)!

        // Act
        let product = try? JSONDecoder().decode(ProductModel.self, from: jsonData)

        // Assert
        XCTAssertNotNil(product)
        XCTAssertEqual(product?.id, "1")
        XCTAssertEqual(product?.name, "Product 1")
        XCTAssertEqual(product?.price, "100")
    }
}
