//
//  GetProductsRequest.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//

struct GetProductsRequest: URLRequestable {
    var path: String { Endpoints.getProducts.value }
    var method: HTTPMethodType { .GET }
    var headers: [String: String]? { nil }
    private let page: Int
    private let limit: Int

    var parameters: [String: Any?]? {
        return ["page": page, "limit": limit]
    }

    init(page: Int, limit: Int) {
        self.page = page
        self.limit = limit
    }
}
