//
//  HomeViewController.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//

import UIKit

import UIKit

class HomeViewController: UIViewController {

    // MARK: - UI Components

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        return searchBar
    }()

    private lazy var filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill

        let filtersLabel = UILabel()
        filtersLabel.text = "Filters:"
        filtersLabel.numberOfLines = 0
        filtersLabel.lineBreakMode = .byWordWrapping
        filtersLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(filtersLabel)

        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(spacerView)

        let selectFilterButton = UIButton(type: .system)
        selectFilterButton.setTitle("Select Filter", for: .normal)
        selectFilterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        selectFilterButton.setContentHuggingPriority(.required, for: .horizontal)
        selectFilterButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(selectFilterButton)

        let clearFiltersButton = UIButton(type: .system)
        clearFiltersButton.setTitle("Clear Filters", for: .normal)
        clearFiltersButton.addTarget(self, action: #selector(clearFilters), for: .touchUpInside)
        clearFiltersButton.setContentHuggingPriority(.required, for: .horizontal)
        clearFiltersButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(clearFiltersButton)

        NSLayoutConstraint.activate([
            selectFilterButton.widthAnchor.constraint(equalToConstant: 100),
            clearFiltersButton.widthAnchor.constraint(equalToConstant: 100)
        ])

        return stackView
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchBar, filterStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        return collectionView
    }()

    private let viewModel = HomeViewModel()
    private let dataSource = HomeDataSource()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "E-Market"
        dataSource.delegate = self
        setupLayout()
        setupBindings()
        
        dataSource.onScrollReachedEnd = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.isSearchActive {
                self.viewModel.searchProducts(query: self.searchBar.text ?? "")
            } else if self.viewModel.isFilterActive {
                self.viewModel.fetchFilteredProducts(
                    sortBy: self.viewModel.activeSortBy,
                    brands: self.viewModel.activeBrands,
                    models: self.viewModel.activeModels
                )
            } else {
                self.viewModel.fetchProducts()
            }
        }

        viewModel.fetchProducts()
    }

    // MARK: - Setup Methods

    private func setupLayout() {
        view.addSubview(headerStackView)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.delegate = self
        dataSource.viewModel = viewModel
    }

    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 16
        let interItemSpacing: CGFloat = 16
        let numberOfItemsPerRow: CGFloat = 2

        let totalPadding = padding * (numberOfItemsPerRow + 1)
        let individualItemWidth = (view.frame.width - totalPadding) / numberOfItemsPerRow

        layout.itemSize = CGSize(width: individualItemWidth, height: 250)
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = interItemSpacing
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return layout
    }

    private func updateFiltersDisplay() {
        var filtersText = "Filters:"

        if let sortBy = viewModel.activeSortBy, !sortBy.isEmpty {
            filtersText += " Sort: \(sortBy)"
        }

        if !viewModel.activeBrands.isEmpty {
            filtersText += " Brands: \(viewModel.activeBrands.joined(separator: ", "))"
        }

        if !viewModel.activeModels.isEmpty {
            filtersText += " Models: \(viewModel.activeModels.joined(separator: ", "))"
        }

        if let filtersLabel = filterStackView.arrangedSubviews.first as? UILabel {
            filtersLabel.text = filtersText
        }
    }

    // MARK: - Actions

    @objc private func filterTapped() {
        print("filter tapped")
        let filterVC = FilterViewController()
        filterVC.delegate = self
        filterVC.modalPresentationStyle = .overFullScreen
        present(filterVC, animated: true)
    }

    @objc private func clearFilters() {
        viewModel.clearFilters()
        viewModel.fetchProducts(reset: true)
        updateFiltersDisplay()
    }
}

// MARK: - ViewModel Delegate

extension HomeViewController: HomeViewModelDelegate {
    func didUpdateProducts() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func didFailWithError(_ error: String) {
        DispatchQueue.main.async {
            print("Error: \(error)")
        }
    }
}

// MARK: - SearchBar Delegate

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.isSearchActive = false
            viewModel.fetchProducts(reset: true)
        } else {
            viewModel.isSearchActive = true
            viewModel.searchProducts(query: searchText, reset: true)
        }
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.isSearchActive = false
        viewModel.fetchProducts(reset: true)
        collectionView.reloadData()
    }
}

// MARK: - Filter Delegate

extension HomeViewController: FilterDelegate {
    func applyFilter(sortBy: String?, brands: [String], models: [String]) {
        viewModel.isFilterActive = true
        viewModel.isSearchActive = false
        viewModel.fetchFilteredProducts(sortBy: sortBy, brands: brands, models: models, reset: true)
        updateFiltersDisplay()
    }
}

extension HomeViewController: HomeDataSourceDelegate {
    func didSelectProduct(_ product: ProductModel) {
        let detailVC = ProductDetailViewController()
        detailVC.product = product
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
