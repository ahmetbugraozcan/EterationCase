//
//  HomeLayoutDelegate.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 26.12.2024.
//

// MARK: - Layout Delegate

import Foundation
import UIKit

class HomeLayoutDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    var onScrollReachedEnd: (() -> Void)?

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let numberOfItemsPerRow: CGFloat = 2
        let totalPadding = padding * (numberOfItemsPerRow + 1)
        let individualItemWidth = (collectionView.frame.width - totalPadding) / numberOfItemsPerRow

        let estimatedTitleHeight: CGFloat = 40
        let estimatedPriceHeight: CGFloat = 20
        let estimatedButtonHeight: CGFloat = 40
        let imageHeight: CGFloat = individualItemWidth * 0.8

        let totalHeight = imageHeight + estimatedTitleHeight + estimatedPriceHeight + estimatedButtonHeight + (padding * 3)
        return CGSize(width: individualItemWidth, height: totalHeight)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 2 {
            onScrollReachedEnd?()
        }
    }
}
