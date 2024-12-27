//
//  BasketViewController.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//

import UIKit

class BasketViewController: UIViewController {
    private let viewModel = BasketViewModel()
    
    private lazy var loadingContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Yarı saydam arka plan
        container.layer.cornerRadius = 10
        container.clipsToBounds = true
        container.isHidden = true
        container.addSubview(loadingIndicator)
        return container
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BasketCell.self, forCellReuseIdentifier: BasketCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.Body1.regular
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete", for: .normal)
        button.backgroundColor = ThemeManager.primaryColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = ThemeManager.CornerRadius.small.rawValue
        button.titleLabel?.font = FontManager.Body1.bold
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(completePurchase), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadBasketProducts()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(totalLabel)
        view.addSubview(completeButton)
        view.addSubview(loadingContainer)

        updateTotalLabel()

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -ThemeManager.Spacing.large.rawValue),
            
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ThemeManager.Spacing.large.rawValue),
            totalLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ThemeManager.Spacing.large.rawValue),
            
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ThemeManager.Spacing.large.rawValue),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ThemeManager.Spacing.large.rawValue),
            completeButton.widthAnchor.constraint(equalToConstant: 120),
            completeButton.heightAnchor.constraint(equalToConstant: 44),

            loadingContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            loadingIndicator.topAnchor.constraint(equalTo: loadingContainer.topAnchor, constant: ThemeManager.Spacing.large.rawValue),
            loadingIndicator.bottomAnchor.constraint(equalTo: loadingContainer.bottomAnchor, constant: -ThemeManager.Spacing.large.rawValue),
            loadingIndicator.leadingAnchor.constraint(equalTo: loadingContainer.leadingAnchor, constant: ThemeManager.Spacing.large.rawValue),
            loadingIndicator.trailingAnchor.constraint(equalTo: loadingContainer.trailingAnchor, constant: -ThemeManager.Spacing.large.rawValue)
        ])
    }
    
    private func setupBindings() {
        viewModel.onProductsUpdated = { [weak self] in
            guard let self = self else { return }
            self.updateTotalLabel()
            self.tableView.reloadData()
        }
        viewModel.delegate = self
    }

    private func updateTotalLabel() {
        let totalText = "Total:\n"
        let priceText = String(format: "%.2f ₺", viewModel.totalPrice)

        let totalAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.Body1.regular,
            .foregroundColor: ThemeManager.primaryColor
        ]
        let priceAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.Body1.regular
        ]
        let attributedString = NSMutableAttributedString(string: totalText, attributes: totalAttributes)
        let priceAttributedString = NSAttributedString(string: priceText, attributes: priceAttributes)
        attributedString.append(priceAttributedString)
        totalLabel.attributedText = attributedString
    }

    @objc private func completePurchase() {
        print("Purchase completed")
    }
}

// MARK: - TableView DataSource & Delegate

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketCell.identifier, for: indexPath) as? BasketCell else {
            return UITableViewCell()
        }
        let product = viewModel.products[indexPath.row]
        let count = viewModel.basketCounts[product.id] ?? 0
        
        cell.configure(with: product, count: count)
        
        let productId = product.id
        cell.onIncrease = { [weak self] _ in
            self?.viewModel.increaseProductCount(for: productId)
        }
        
        cell.onDecrease = { [weak self] _ in
            self?.viewModel.decreaseProductCount(for: productId)
        }
        
        return cell
    }
}

extension BasketViewController: BasketViewModelDelegate {
    func didChangeLoadingState(isLoading: Bool) {
        DispatchQueue.main.async {
            self.loadingContainer.isHidden = !isLoading
            if isLoading {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
        }
    }
}
