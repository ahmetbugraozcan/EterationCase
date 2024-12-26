//
//  BasketViewModel.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 26.12.2024.
//

import Foundation

class BasketViewModel {
    private let basketManager = BasketManager.shared
    private(set) var products: [ProductModel] = []
    private(set) var basketCounts: [String: Int] = [:]
    var onProductsUpdated: (() -> Void)?
    var totalPrice: Int {
        return products.reduce(0) { $0 + ((Int($1.price) ?? 0) * (basketCounts[$1.id] ?? 0)) }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBasket), name: .basketUpdated, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func reloadBasket() {
        loadBasketProducts()
//        let basketItems = basketManager.fetchBasketItems()
//        basketCounts = Dictionary(uniqueKeysWithValues: basketItems.compactMap { ($0.id ?? "", Int($0.basketCount)) })
//        onProductsUpdated?()
    }

    func loadBasketProducts() {
        let basketItems = basketManager.fetchBasketItems()
        basketCounts = Dictionary(uniqueKeysWithValues: basketItems.compactMap { ($0.id ?? "", Int($0.basketCount)) })

        let ids = basketItems.compactMap { $0.id }.sorted() // ID'leri sıralayalım
        let dispatchGroup = DispatchGroup()
        var fetchedProducts: [ProductModel] = []

        for id in ids {
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
            // Ürünleri ID'ye göre sıralayalım
            self.products = fetchedProducts.sorted { $0.id < $1.id }
            self.onProductsUpdated?()
        }
    }
    
    func increaseProductCount(for id: String) {
        DispatchQueue.main.async {
            self.basketManager.increaseBasketCount(for: id)
            // basketCounts güncellenmesi NotificationCenter üzerinden gelecek
        }
    }
    
    func decreaseProductCount(for id: String) {
        DispatchQueue.main.async {
            self.basketManager.decreaseBasketCount(for: id)
            // basketCounts güncellenmesi NotificationCenter üzerinden gelecek
        }
    }
}
