//
//  HomeViewModel.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didUpdateProducts()
    func didFailWithError(_ error: String)
}

class HomeViewModel {
    private var currentPage = 1
    private let limit = 4
    private var isFetching = false

    private var searchPage = 1
    private var isSearching = false

    private var filterPage = 1
    private var isFiltering = false

    var products: [ProductModel] = []
    var searchResults: [ProductModel] = []
    var filteredProducts: [ProductModel] = []

    var activeSortBy: String?
    var activeBrands: [String] = []
    var activeModels: [String] = []

    weak var delegate: HomeViewModelDelegate?

    var isSearchActive: Bool = false
    var isFilterActive: Bool = false

    func fetchProducts(reset: Bool = false) {
        guard !isFetching else { return }
        isFetching = true

        if reset {
            currentPage = 1
            products.removeAll()
        }

        let request = GetProductsRequest(page: currentPage, limit: limit)
        NetworkManager.shared.request(requestable: request, responseType: [ProductModel].self) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            switch result {
            case .success(let fetchedProducts):
                self.products.append(contentsOf: fetchedProducts)
                self.currentPage += 1
                self.delegate?.didUpdateProducts()
            case .failure(let error):
                self.delegate?.didFailWithError(error.localizedDescription)
            }
        }
    }

    func searchProducts(query: String, reset: Bool = false) {
        guard !isSearching else { return }
        isSearching = true

        if reset {
            searchPage = 1
            searchResults.removeAll()
        }

        let request = SearchProductsRequest(page: searchPage, limit: limit, search: query)
        NetworkManager.shared.request(requestable: request, responseType: [ProductModel].self) { [weak self] result in
            guard let self = self else { return }
            self.isSearching = false

            switch result {
            case .success(let fetchedSearchResults):
                self.searchResults.append(contentsOf: fetchedSearchResults)
                self.searchPage += 1
                self.delegate?.didUpdateProducts()
            case .failure(let error):
                self.delegate?.didFailWithError(error.localizedDescription)
            }
        }
    }

    func fetchFilteredProducts(sortBy: String?, brands: [String], models: [String], reset: Bool = false) {
        guard !isFiltering else { return }
        isFiltering = true

        if reset {
            filterPage = 1
            filteredProducts.removeAll()
            activeSortBy = sortBy
            activeBrands = brands
            activeModels = models
        }

        let request = GetFilteredProductsRequest(page: filterPage, limit: limit, brands: brands, models: models)
        NetworkManager.shared.request(requestable: request, responseType: [ProductModel].self) { [weak self] result in
            guard let self = self else { return }
            self.isFiltering = false

            switch result {
            case .success(let fetchedFilteredProducts):
                self.filteredProducts.append(contentsOf: fetchedFilteredProducts)
                self.filterPage += 1
                self.delegate?.didUpdateProducts()
            case .failure(let error):
                self.delegate?.didFailWithError(error.localizedDescription)
            }
        }
    }

    func clearFilters() {
        isFilterActive = false
        activeSortBy = nil
        activeBrands.removeAll()
        activeModels.removeAll()
        filteredProducts.removeAll()
        filterPage = 1
    }
}
