//
//  ProductModel.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//

struct ProductModel: Decodable {
    let id: String
    let name: String
    let image: String
    let price: String
    let description: String
    let model: String
    let brand: String
    let createdAt: String
}
