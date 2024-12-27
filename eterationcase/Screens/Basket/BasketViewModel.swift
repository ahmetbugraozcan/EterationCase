//
//  BasketViewModel.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 26.12.2024.
//

import Foundation

protocol BasketViewModelDelegate: AnyObject {
    func didChangeLoadingState(isLoading: Bool)
}

class BasketViewModel {
    private let basketManager = BasketManager.shared
    private(set) var products: [ProductModel] = []
    private(set) var basketCounts: [String: Int] = [:]
    var onProductsUpdated: (() -> Void)?
    var totalPrice: Double = 0
    weak var delegate: BasketViewModelDelegate?

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBasket), name: .basketUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCounts), name: .countChanged, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setLoadingState(_ isLoading: Bool) {
        delegate?.didChangeLoadingState(isLoading: isLoading)
    }

    @objc private func reloadBasket() {
        loadBasketProducts()
    }

    func loadBasketProducts() {
        setLoadingState(true)
        let basketItems = basketManager.fetchBasketItems()
        basketCounts = Dictionary(uniqueKeysWithValues: basketItems.compactMap { ($0.id ?? "", Int($0.basketCount)) })

        let ids = basketItems.compactMap { $0.id }.sorted()
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
            self.products = fetchedProducts.sorted { $0.id < $1.id }
            self.calculateTotalPrice()
            self.setLoadingState(false)
            self.onProductsUpdated?()
        }
    }

    func increaseProductCount(for id: String) {
        DispatchQueue.main.async {
            self.basketManager.increaseBasketCount(for: id)
            self.updateCounts()
        }
    }

    func decreaseProductCount(for id: String) {
        DispatchQueue.main.async {
            self.basketManager.decreaseBasketCount(for: id)
            self.updateCounts()
        }
    }

    @objc private func updateCounts() {
        let basketItems = basketManager.fetchBasketItems()
        basketCounts = Dictionary(uniqueKeysWithValues: basketItems.compactMap { ($0.id ?? "", Int($0.basketCount)) })
        self.calculateTotalPrice()
        onProductsUpdated?()
    }

    private func calculateTotalPrice() {
        totalPrice = products.reduce(0) { result, product in
            guard let count = basketCounts[product.id], let price = Double(product.price) else { return result }
            return result + (Double(count) * price)
        }
    }
}
