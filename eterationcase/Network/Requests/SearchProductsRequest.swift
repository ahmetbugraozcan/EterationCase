//
//  SearchProductsRequest.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//

struct SearchProductsRequest: URLRequestable {
    var path: String { Endpoints.getProducts.value }
    var method: HTTPMethodType { .GET }
    var headers: [String: String]? { nil }

    private let page: Int
    private let limit: Int
    private let search: String

    var parameters: [String: Any?]? {
        return [
            Parameters.search.rawValue: search,
            Parameters.page.rawValue: page,
            Parameters.limit.rawValue: limit
        ]
    }

    init(page: Int, limit: Int, search: String) {
        self.page = page
        self.limit = limit
        self.search = search
    }
}
