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
    private let sortOption: String?
    private let sortField: String?

    var parameters: [String: Any?]? {
        return [
            Parameters.page.rawValue: page,
            Parameters.limit.rawValue: limit,
            Parameters.brand.rawValue: brand,
            Parameters.model.rawValue: model,
            Parameters.sortBy.rawValue: sortOption,
            Parameters.order.rawValue: sortField
        ]
    }

    init(
        page: Int,
        limit: Int,
        brands: [String],
        models: [String],
        sortField: String?,
        sortOption: String?
    ) {
        self.page = page
        self.limit = limit
        self.brand = brands.joined(separator: "|")
        self.model = models.joined(separator: "|")
        self.sortField = sortField
        self.sortOption = sortOption
    }
}
