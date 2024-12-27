//
//  HomeLayoutDelegate.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 26.12.2024.
//

// MARK: - Layout Delegate

import Foundation
import UIKit

class HomeCompositionalLayout {
    static func createLayout(
        itemsPerRow: Int = 2,
        itemSpacing: CGFloat = ThemeManager.Spacing.medium.rawValue,
        estimatedHeight: CGFloat = 300) -> UICollectionViewCompositionalLayout {
        let itemWidth = 1.0 / CGFloat(itemsPerRow)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemWidth),
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpacing

        return UICollectionViewCompositionalLayout(section: section)
    }
}

