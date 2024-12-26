//
//  ProductDetailViewController.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 26.12.2024.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    // MARK: - Properties
    var product: ProductModel?
    
    // MARK: - UI Components
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Basket", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureProductDetails()
        setupActions()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.addSubview(productImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(priceLabel)
        view.addSubview(addToCartButton)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            productImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            productImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            productImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            addToCartButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            addToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureProductDetails() {
        guard let product = product else { return }
        titleLabel.text = product.name
        descriptionLabel.text = product.description
        priceLabel.text = "Price: \(product.price) ₺"
        
        guard let imageURL = URL(string: product.image) else { return }

        if let cachedImage = ImageCache.shared.object(forKey: product.image as NSString) {
            productImageView.image = cachedImage
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL),
               let image = UIImage(data: data) {
                ImageCache.shared.setObject(image, forKey: product.image as NSString)

                DispatchQueue.main.async {
                    self.productImageView.image = image
                }
            }
        }
    }
    
    private func setupActions() {
        addToCartButton.addTarget(self, action: #selector(addToBasket), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func addToBasket() {
        guard let product = product else { return }
        
        if BasketManager.shared.isProductInBasket(productId: product.id) {
            showAlert(title: "Already Added", message: "This product is already in your basket.")
        } else {
            BasketManager.shared.addToBasket(productId: product.id, basketCount: 1)
            showAlert(title: "Success", message: "Product added to your basket.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
