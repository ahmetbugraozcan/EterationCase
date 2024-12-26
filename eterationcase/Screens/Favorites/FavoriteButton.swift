//
//  FavoriteButton.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 26.12.2024.
//

import UIKit

protocol FavoriteButtonDelegate: AnyObject {
    func didToggleFavorite(isFavorited: Bool)
}

class FavoriteButton: UIButton {
    weak var delegate: FavoriteButtonDelegate?

    private var isFavorited: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateAppearance()
    }

    private func updateAppearance() {
        let imageName = isFavorited ? "star.fill" : "star"
        let image = UIImage(systemName: imageName)?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        setImage(image, for: .normal)
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
    }

    @objc private func toggleFavorite() {
        isFavorited.toggle()
        delegate?.didToggleFavorite(isFavorited: isFavorited)
    }
    
    func setFavorite(_ isFavorite: Bool) {
        isFavorited = isFavorite
    }
}
