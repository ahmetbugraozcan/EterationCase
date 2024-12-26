//
//  FavoritesViewModel.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 26.12.2024.
//

import Foundation

class FavoritesViewModel {
    private let favoriteManager = FavoriteManager.shared
    private(set) var products: [ProductModel] = []
    var onProductsUpdated: (() -> Void)?
    
    func loadFavorites() {
        let favoriteItems = favoriteManager.getAllFavoriteItems() // Favori ürünlerin id'lerini çek
        let ids = favoriteItems.map { $0.id }
        
        let dispatchGroup = DispatchGroup()
        var fetchedProducts: [ProductModel] = []
        
        for id in ids {
            guard let id = id else { return }
            dispatchGroup.enter()
            let request = GetProductByIdRequest(page: 1, limit: 1, id: id)
            NetworkManager.shared.request(requestable: request, responseType: ProductModel.self) { result in
                switch result {
                case .success(let product):
                    fetchedProducts.append(product)
                case .failure(let error):
                    print("Failed to fetch product with ID \(id): \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.products = fetchedProducts
            self.onProductsUpdated?()
        }
    }
}
