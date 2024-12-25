//
//  Endpoints.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//

// MARK: Endpoints enum
enum Endpoints {
    case getProducts
}

extension Endpoints {
    var value: String {
        switch self {
        case .getProducts:
            return "/products"
        }
    }
}
