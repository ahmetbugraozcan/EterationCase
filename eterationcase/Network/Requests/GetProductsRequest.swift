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
    var parameters: [String: Any]? { nil }
}
