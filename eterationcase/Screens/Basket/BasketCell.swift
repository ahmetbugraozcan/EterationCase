//
//  BasketCell.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 26.12.2024.
//

import UIKit

class BasketCell: UITableViewCell {
    static let identifier = "BasketCell"
    
    var onIncrease: ((_ productId: String) -> Void)?
    var onDecrease: ((_ productId: String) -> Void)?
    
    private var productId: String? // Product ID to ensure correct mapping
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let quantityContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(quantityContainerView)
        
        quantityContainerView.addSubview(decreaseButton)
        quantityContainerView.addSubview(countLabel)
        quantityContainerView.addSubview(increaseButton)
        
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            // Price Label
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            // Quantity Container
            quantityContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            quantityContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            quantityContainerView.widthAnchor.constraint(equalToConstant: 120),
            quantityContainerView.heightAnchor.constraint(equalToConstant: 36),
            
            // Decrease Button
            decreaseButton.leadingAnchor.constraint(equalTo: quantityContainerView.leadingAnchor),
            decreaseButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 40),
            
            // Count Label
            countLabel.centerXAnchor.constraint(equalTo: quantityContainerView.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            countLabel.widthAnchor.constraint(equalToConstant: 40),
            
            // Increase Button
            increaseButton.trailingAnchor.constraint(equalTo: quantityContainerView.trailingAnchor),
            increaseButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            increaseButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with product: ProductModel, count: Int) {
        self.productId = product.id // Associate the product ID
        titleLabel.text = product.name
        priceLabel.text = "\(product.price) ₺"
        countLabel.text = "\(count)"
    }
    
    @objc private func increaseTapped() {
        guard let productId = productId else { return }
        onIncrease?(productId) // Pass the product ID
    }
    
    @objc private func decreaseTapped() {
        guard let productId = productId else { return }
        onDecrease?(productId) // Pass the product ID
    }
}
