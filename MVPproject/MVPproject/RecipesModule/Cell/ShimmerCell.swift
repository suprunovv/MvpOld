// ShimmerCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с шимером для экрана с выбором категорий рецептов
final class ShimmerCell: UICollectionViewCell {
    // MARK: - Constants

    static let reuseID = String(describing: ShimmerCell.self)

    // MARK: - Initializators

    override init(frame: CGRect) {
        super.init(frame: frame)
        startShimmerAnimation(cell: self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func startShimmerAnimation(cell: UICollectionViewCell) {
        let shimmerView = ShimmerView(frame: cell.contentView.bounds)
        cell.contentView.addSubview(shimmerView)
    }
}
