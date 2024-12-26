//
//  FilterViewController.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//
import UIKit

protocol FilterDelegate: AnyObject {
    func applyFilter(sortBy: String?, brands: [String], models: [String])
}

class FilterViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    weak var delegate: FilterDelegate?

    private let sortOptions = ["Old to new", "New to old", "Price high to low", "Price low to High"]
    private let brandOptions = [
        "Lamborghini", "Smart", "Ferrari", "Volkswagen", "Mercedes Benz",
        "Tesla", "Fiat", "Land Rover", "Aston Martin", "Maserati",
        "Bugatti", "Nissan", "Audi", "Rolls Royce", "Mini",
        "BMW", "Jeep", "Kia", "Mazda", "Dodge", "Toyota"
    ]

    private let modelOptions = [
        "CTS", "Roadster", "Taurus", "Jetta", "Fortwo",
        "A4", "XC90", "Expedition", "Focus", "Model S",
        "F-150", "Corvette", "Ranchero", "Colorado", "911",
        "El Camino", "Grand Cherokee", "Alpine", "Beetle", "Model T",
        "Mustang", "Malibu", "Accord", "Spyder", "Camry",
        "Explorer", "Element", "Charger", "Silverado", "LeBaron",
        "Challenger", "XTS", "Volt", "Altima", "Golf"
    ]

    private var selectedSortOption: String?
    private var selectedBrands: Set<String> = []
    private var selectedModels: Set<String> = []

    private var filteredBrandOptions: [String] = []
    private var filteredModelOptions: [String] = []

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let sortStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let brandLabel: UILabel = {
        let label = UILabel()
        label.text = "Brand"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let brandSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Brand"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let brandCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.tag = 0
        return collectionView
    }()

    private let modelLabel: UILabel = {
        let label = UILabel()
        label.text = "Model"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let modelSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Model"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let modelCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.tag = 1
        return collectionView
    }()

    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Primary", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        setupCollectionViews()

        filteredBrandOptions = brandOptions
        filteredModelOptions = modelOptions
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(sortStackView)
        view.addSubview(brandLabel)
        view.addSubview(brandSearchBar)
        view.addSubview(brandCollectionView)
        view.addSubview(modelLabel)
        view.addSubview(modelSearchBar)
        view.addSubview(modelCollectionView)
        view.addSubview(applyButton)

        sortOptions.forEach { option in
            let radioButton = createRadioButton(title: option)
            sortStackView.addArrangedSubview(radioButton)
        }
    }

    private func setupConstraints() {
        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),

            sortStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            sortStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            sortStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),

            brandLabel.topAnchor.constraint(equalTo: sortStackView.bottomAnchor, constant: padding * 2),
            brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),

            brandSearchBar.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: padding),
            brandSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            brandSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            brandCollectionView.topAnchor.constraint(equalTo: brandSearchBar.bottomAnchor, constant: padding),
            brandCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            brandCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            brandCollectionView.heightAnchor.constraint(equalToConstant: 150),

            modelLabel.topAnchor.constraint(equalTo: brandCollectionView.bottomAnchor, constant: padding * 2),
            modelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),

            modelSearchBar.topAnchor.constraint(equalTo: modelLabel.bottomAnchor, constant: padding),
            modelSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modelSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            modelCollectionView.topAnchor.constraint(equalTo: modelSearchBar.bottomAnchor, constant: padding),
            modelCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            modelCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            modelCollectionView.heightAnchor.constraint(equalToConstant: 150),

            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        brandSearchBar.delegate = self
        modelSearchBar.delegate = self
    }

    private func setupCollectionViews() {
        brandCollectionView.delegate = self
        brandCollectionView.dataSource = self
        brandCollectionView.register(FilterOptionCell.self, forCellWithReuseIdentifier: FilterOptionCell.identifier)

        modelCollectionView.delegate = self
        modelCollectionView.dataSource = self
        modelCollectionView.register(FilterOptionCell.self, forCellWithReuseIdentifier: FilterOptionCell.identifier)
    }

    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func applyButtonTapped() {
        delegate?.applyFilter(sortBy: selectedSortOption, brands: Array(selectedBrands), models: Array(selectedModels))
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == brandSearchBar {
            filteredBrandOptions = searchText.isEmpty ? brandOptions : brandOptions.filter { $0.localizedCaseInsensitiveContains(searchText) }
            brandCollectionView.reloadData()
        } else if searchBar == modelSearchBar {
            filteredModelOptions = searchText.isEmpty ? modelOptions : modelOptions.filter { $0.localizedCaseInsensitiveContains(searchText) }
            modelCollectionView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        if searchBar == brandSearchBar {
            filteredBrandOptions = brandOptions
            brandCollectionView.reloadData()
        } else if searchBar == modelSearchBar {
            filteredModelOptions = modelOptions
            modelCollectionView.reloadData()
        }
    }

    // MARK: - UICollectionViewDelegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.tag == 0 ? filteredBrandOptions.count : filteredModelOptions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterOptionCell.identifier, for: indexPath) as? FilterOptionCell else {
            return UICollectionViewCell()
        }

        let title = collectionView.tag == 0 ? filteredBrandOptions[indexPath.item] : filteredModelOptions[indexPath.item]
        let isSelected = collectionView.tag == 0 ? selectedBrands.contains(title) : selectedModels.contains(title)

        cell.configure(with: title, isSelected: isSelected) { [weak self] tappedTitle, isSelected in
            guard let self = self else { return }
            if collectionView.tag == 0 { // Brand
                if isSelected {
                    self.selectedBrands.insert(tappedTitle)
                } else {
                    self.selectedBrands.remove(tappedTitle)
                }
            } else { // Model
                if isSelected {
                    self.selectedModels.insert(tappedTitle)
                } else {
                    self.selectedModels.remove(tappedTitle)
                }
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 16
        return CGSize(width: width, height: 40)
    }

    // MARK: - Helper Methods
    private func createRadioButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        button.setTitle("  \(title)", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.tintColor = .systemBlue
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        return button
    }

    @objc private func radioButtonTapped(_ sender: UIButton) {
        sortStackView.arrangedSubviews.forEach { view in
            guard let button = view as? UIButton else { return }
            button.isSelected = button == sender
        }
        selectedSortOption = sender.title(for: .normal)?.trimmingCharacters(in: .whitespaces)
    }
}
