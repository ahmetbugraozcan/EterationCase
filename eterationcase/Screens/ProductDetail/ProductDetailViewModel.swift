//
//  ProductDetailViewModel.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 27.12.2024.
//

import Foundation

class ProductDetailViewModel {
    // MARK: - Properties
    private(set) var product: ProductModel?
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    // MARK: - Callbacks
    var onProductFetched: ((ProductModel) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onErrorOccurred: ((String) -> Void)?

    // MARK: - Methods
    func fetchProduct(by id: String) {
        setLoadingState(true)

        let request = GetProductByIdRequest(page: 1, limit: 1, id: id)

        NetworkManager.shared.request(requestable: request, responseType: ProductModel.self) { [weak self] result in
            guard let self = self else { return }

            self.setLoadingState(false)

            switch result {
            case .success(let product):
                self.product = product
                self.onProductFetched?(product)
            case .failure(let error):
                let errorMessage = "Failed to fetch product: \(error.localizedDescription)"
                self.errorMessage = errorMessage
                self.onErrorOccurred?(errorMessage)
            }
        }
    }

    private func setLoadingState(_ isLoading: Bool) {
        self.isLoading = isLoading
        self.onLoadingStateChanged?(isLoading)
    }
}
