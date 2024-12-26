//
//  GetFilteredProductsRequest.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 26.12.2024.
//

struct GetFilteredProductsRequest: URLRequestable {
    var path: String { Endpoints.getProducts.value }
    var method: HTTPMethodType { .GET }
    var headers: [String: String]? { nil }
    private let page: Int
    private let limit: Int
    private let brand: String
    private let model: String

    var parameters: [String: Any]? {
        return ["page": page, "limit": limit, "brand": brand, "model": model]
    }

    init(page: Int, limit: Int, brands: [String], models: [String]) {
        self.page = page
        self.limit = limit
        self.brand = brands.joined(separator: "|")
        self.model = models.joined(separator: "|")
    }
}
