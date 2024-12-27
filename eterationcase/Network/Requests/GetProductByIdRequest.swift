//
//  GetProductById.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 26.12.2024.
//

struct GetProductByIdRequest: URLRequestable {
    var path: String
    var method: HTTPMethodType { .GET }
    var headers: [String: String]? { nil }
    private let page: Int
    private let limit: Int

    var parameters: [String: Any?]? {
        return ["page": page, "limit": limit]
    }

    init(page: Int, limit: Int, id: String) {
        self.page = page
        self.limit = limit
        self.path = Endpoints.getProductById(id).value
    }
}
