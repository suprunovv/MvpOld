// RecipesCategoryCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячека типа рецепта
final class RecipesCategoryCell: UICollectionViewCell {
    // MARK: - Constants

    static let reuseID = "RecipesCategoryCell"

    // MARK: - Visual Components

    private let titleImageView = UIImageView()

    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.disableAutoresizingMask()
        view.alpha = 0.7
        return view
    }()

    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.textAlignment = .center
        label.disableAutoresizingMask()
        return label
    }()

    // MARK: - Initializators

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public methods

    func setupCell(category: RecipesCategoryCellConfig) {
        bottomLabel.text = category.recipeCategory.name
        titleImageView.image = UIImage(named: category.recipeCategory.imageName)
    }

    // MARK: - Private methods

    private func setViews() {
        contentView.layer.cornerRadius = contentView.bounds.width / 10
        setTitleImageViewConstaints()
        setBottomViewConstaints()
        setBottomLabelConstaints()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3
        contentView.layer.shadowOpacity = 0.5
        contentView.clipsToBounds = true
        layer.masksToBounds = false
    }

    private func setTitleImageViewConstaints() {
        contentView.addSubview(titleImageView)
        titleImageView.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: topAnchor),
            titleImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    private func setBottomViewConstaints() {
        contentView.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    private func setBottomLabelConstaints() {
        contentView.addSubview(bottomLabel)
        NSLayoutConstraint.activate([
            bottomLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
        ])
    }
}
