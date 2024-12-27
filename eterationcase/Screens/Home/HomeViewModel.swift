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
    func didChangeLoadingState(isLoading: Bool)
}

class HomeViewModel {
    private var currentPage = 1
    private let limit = 4
    private var isFetching = false
    private var hasMoreData = true

    private var searchPage = 1
    private var isSearching = false
    private var hasMoreSearchData = true

    private var filterPage = 1
    private var isFiltering = false
    private var hasMoreFilteredData = true

    var products: [ProductModel] = []
    var searchResults: [ProductModel] = []
    var filteredProducts: [ProductModel] = []

    var activeSortBy: SortModel?
    var activeBrands: [String] = []
    var activeModels: [String] = []

    weak var delegate: HomeViewModelDelegate?

    var isSearchActive: Bool = false
    var isFilterActive: Bool = false

    private func setLoadingState(_ isLoading: Bool) {
        delegate?.didChangeLoadingState(isLoading: isLoading)
    }

    func fetchProducts(reset: Bool = false) {
        guard !isFetching, hasMoreData else { return }
        isFetching = true
        setLoadingState(true)

        if reset {
            currentPage = 1
            products.removeAll()
            hasMoreData = true
        }

        let request = GetProductsRequest(page: currentPage, limit: limit)
        NetworkManager.shared.request(requestable: request, responseType: [ProductModel].self) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            self.setLoadingState(false)

            switch result {
            case .success(let fetchedProducts):
                if fetchedProducts.isEmpty {
                    self.hasMoreData = false
                } else {
                    self.products.append(contentsOf: fetchedProducts)
                    self.currentPage += 1
                }
                self.delegate?.didUpdateProducts()
            case .failure(let error):
                self.delegate?.didFailWithError(error.localizedDescription)
            }
        }
    }

    func searchProducts(query: String, reset: Bool = false) {
        guard !isSearching, hasMoreSearchData else { return }
        isSearching = true
        setLoadingState(true)

        if reset {
            searchPage = 1
            searchResults.removeAll()
            hasMoreSearchData = true
        }

        let request = SearchProductsRequest(page: searchPage, limit: limit, search: query)
        NetworkManager.shared.request(requestable: request, responseType: [ProductModel].self) { [weak self] result in
            guard let self = self else { return }
            self.isSearching = false
            self.setLoadingState(false)
            switch result {
            case .success(let fetchedSearchResults):
                if fetchedSearchResults.isEmpty {
                    self.hasMoreSearchData = false
                } else {
                    self.searchResults.append(contentsOf: fetchedSearchResults)
                    self.searchPage += 1
                }
                self.delegate?.didUpdateProducts()
            case .failure(let error):
                self.delegate?.didFailWithError(error.localizedDescription)
            }
        }
    }

    func fetchFilteredProducts(sortBy: SortModel?, brands: [String], models: [String], reset: Bool = false) {
        if reset {
            filterPage = 1
            filteredProducts.removeAll()
            activeSortBy = sortBy
            activeBrands = brands
            activeModels = models
            hasMoreFilteredData = true
        }

        guard !isFiltering, hasMoreFilteredData else { return }
        isFiltering = true
        setLoadingState(true)

        let request = GetFilteredProductsRequest(
            page: filterPage,
            limit: limit,
            brands: brands,
            models: models,
            sortField: sortBy?.getSortType().rawValue,
            sortOption: sortBy?.getPath()
        )

        NetworkManager.shared.request(requestable: request, responseType: [ProductModel].self) { [weak self] result in
            guard let self = self else { return }
            self.isFiltering = false
            self.setLoadingState(false)
            switch result {
            case .success(let fetchedFilteredProducts):
                if fetchedFilteredProducts.isEmpty {
                    self.hasMoreFilteredData = false
                } else {
                    self.filteredProducts.append(contentsOf: fetchedFilteredProducts)
                    self.filterPage += 1
                }
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
        hasMoreFilteredData = true
    }

    func handleScrollReachedEnd(searchQuery: String?) {
        if isSearchActive {
            searchProducts(query: searchQuery ?? "")
        } else if isFilterActive {
            fetchFilteredProducts(
                sortBy: activeSortBy,
                brands: activeBrands,
                models: activeModels
            )
        } else {
            fetchProducts()
        }
    }
}
