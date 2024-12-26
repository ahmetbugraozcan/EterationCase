//
//  ProductCell.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func didTapAddToBasket(for product: ProductModel)
}

class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    
    weak var delegate: ProductCellDelegate?
    private var product: ProductModel?
    var onAddToBasket: (() -> Void)?

    private let favoriteButton: FavoriteButton = {
        let button = FavoriteButton()
        return button
    }()

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .left
        return label
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Basket", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(addToBasketTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImageView, titleLabel, priceLabel, addToCartButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.masksToBounds = true

        // StackView ve diğer bileşenleri ekle
        contentView.addSubview(stackView)
        contentView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.bringSubviewToFront(favoriteButton)

        favoriteButton.delegate = self

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),

            // Favorite button constraints
            favoriteButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 28),
            favoriteButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(product: ProductModel) {
        self.product = product
        titleLabel.text = product.name
        priceLabel.text = "\(product.price) ₺"
        
        productImageView.image = UIImage(named: "placeholder")

        guard let imageURL = URL(string: product.image) else { return }

        if let cachedImage = ImageCache.shared.object(forKey: product.image as NSString) {
            productImageView.image = cachedImage
            return
        }

        let isInFavorites = FavoriteManager.shared.isProductInFavorites(productId: product.id)
        favoriteButton.setFavorite(isInFavorites)

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
    
    @objc private func addToBasketTapped() {
        guard let product = product else { return }
        delegate?.didTapAddToBasket(for: product)
    }
}

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

extension ProductCell: FavoriteButtonDelegate {
    func didToggleFavorite(isFavorited: Bool) {
        guard let productId = product?.id else { return }
        if isFavorited {
            FavoriteManager.shared.addToFavorites(productId: productId)
        } else {
            FavoriteManager.shared.removeFromFavorites(productId: productId)
        }
    }
}
