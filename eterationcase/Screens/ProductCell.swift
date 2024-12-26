//
//  ProductCell.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 25.12.2024.
//

import UIKit

// MARK: - ProductCell
class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    
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
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
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
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40) // Sabit buton yüksekliği
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(product: ProductModel) {
        titleLabel.text = product.name
        priceLabel.text = "\(product.price) ₺"
        
        productImageView.image = UIImage(named: "placeholder")

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

}
        
class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
