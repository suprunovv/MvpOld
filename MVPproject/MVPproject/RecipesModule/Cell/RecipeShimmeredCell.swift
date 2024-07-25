// RecipeShimmeredCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Плейсхолдер для ячейки рецепта
final class RecipeShimmeredCell: UITableViewCell {
    // MARK: - Constants

    private enum Constants {
        static let panelCornerRadius = 12.0
        static let panelHeight = 100.0
        static let cellInnerSpacing = 10.0
        static let cellOuterSpacing = (x: 20.0, y: 7.0)
        static let recipeImageCornerRadius = 12.0
        static let recipeImageSize = 80.0
        static let imageToContentSpacing = 20.0
        static let nameInnerSpacing = 12.0
        static let recipeNameToViewSpacing = 43.0
        static let infoToNameSpacing = 8.0
        static let infoSpacing = 10.0
        static let recipeNameLabelSize = CGSize(width: 197, height: 32)
        static let cookingTimeSize = CGSize(width: 74, height: 15)
        static let caloriesSize = CGSize(width: 91, height: 15)
    }

    static let reuseID = String(describing: RecipeShimmeredCell.self)

    // MARK: - Visual Components

    private let recipeView = UIView()
    private let recipeImageView = UIView()
    private let recipeNameView = UIView()
    private let cookingTimeView = UIView()
    private let caloriesView = UIView()
    private let recipeImageShimmerLayer = ShimmerLayer(clearColor: .greenBgAccent)
    private let recipeNameShimmerLayer = ShimmerLayer(clearColor: .greenBgAccent)
    private let cookingTimeShimmerLayer = ShimmerLayer(clearColor: .greenBgAccent)
    private let caloriesShimmerLayer = ShimmerLayer(clearColor: .greenBgAccent)

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        recipeImageView.layoutIfNeeded()
        recipeNameView.layoutIfNeeded()
        cookingTimeView.layoutIfNeeded()
        caloriesView.layoutIfNeeded()
        recipeImageShimmerLayer.frame = recipeImageView.bounds
        recipeNameShimmerLayer.frame = recipeNameView.bounds
        cookingTimeShimmerLayer.frame = cookingTimeView.bounds
        caloriesShimmerLayer.frame = caloriesView.bounds
    }

    // MARK: - Private Methods

    private func setupCell() {
        recipeView.addSubviews(recipeImageView, cookingTimeView, caloriesView, recipeNameView)
        contentView.addSubview(recipeView)
        addShimmerLayers()
        setupRecipeView()
        setupRecipeImageView()
        setupRecipeNameView()
        setupCookingTimeView()
        setupCaloriesView()
    }

    private func addShimmerLayers() {
        recipeImageView.layer.addSublayer(recipeImageShimmerLayer)
        recipeNameView.layer.addSublayer(recipeNameShimmerLayer)
        cookingTimeView.layer.addSublayer(cookingTimeShimmerLayer)
        caloriesView.layer.addSublayer(caloriesShimmerLayer)
    }

    private func setupRecipeView() {
        recipeView.disableAutoresizingMask()
        recipeView.backgroundColor = .greenBgAccent
        recipeView.layer.cornerRadius = Constants.panelCornerRadius
        NSLayoutConstraint.activate([
            recipeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellOuterSpacing.y),
            recipeView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.cellOuterSpacing.x
            ),
            contentView.trailingAnchor.constraint(
                equalTo: recipeView.trailingAnchor, constant: Constants.cellOuterSpacing.x
            ),
            contentView.bottomAnchor.constraint(
                equalTo: recipeView.bottomAnchor,
                constant: Constants.cellOuterSpacing.y
            ),
            recipeView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.panelHeight),
        ])
    }

    private func setupRecipeImageView() {
        recipeImageView.disableAutoresizingMask()
        recipeImageView.layer.cornerRadius = Constants.recipeImageCornerRadius
        recipeImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: recipeView.topAnchor, constant: Constants.cellInnerSpacing),
            recipeImageView.leadingAnchor.constraint(
                equalTo: recipeView.leadingAnchor,
                constant: Constants.cellInnerSpacing
            ),
            recipeView.bottomAnchor.constraint(
                equalTo: recipeImageView.bottomAnchor,
                constant: Constants.cellInnerSpacing
            ),
            recipeImageView.widthAnchor.constraint(equalTo: recipeImageView.heightAnchor)
        ])
    }

    private func setupRecipeNameView() {
        recipeNameView.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            recipeNameView.heightAnchor.constraint(equalToConstant: Constants.recipeNameLabelSize.height),
            recipeNameView.topAnchor.constraint(
                equalTo: recipeImageView.topAnchor,
                constant: Constants.nameInnerSpacing
            ),
            recipeNameView.leadingAnchor.constraint(
                equalTo: recipeImageView.trailingAnchor,
                constant: Constants.imageToContentSpacing
            ),
            recipeView.trailingAnchor.constraint(
                equalTo: recipeNameView.trailingAnchor,
                constant: Constants.recipeNameToViewSpacing
            )
        ])
    }

    private func setupCookingTimeView() {
        cookingTimeView.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            cookingTimeView.heightAnchor.constraint(equalToConstant: Constants.cookingTimeSize.height),
            cookingTimeView.widthAnchor.constraint(equalToConstant: Constants.cookingTimeSize.width),
            cookingTimeView.leadingAnchor.constraint(equalTo: recipeNameView.leadingAnchor),
            cookingTimeView.topAnchor.constraint(
                equalTo: recipeNameView.bottomAnchor,
                constant: Constants.infoToNameSpacing
            ),
        ])
    }

    private func setupCaloriesView() {
        caloriesView.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            caloriesView.topAnchor.constraint(equalTo: cookingTimeView.topAnchor),
            caloriesView.leadingAnchor.constraint(
                equalTo: cookingTimeView.trailingAnchor,
                constant: Constants.infoSpacing
            ),
            caloriesView.heightAnchor.constraint(equalToConstant: Constants.caloriesSize.height),
            caloriesView.widthAnchor.constraint(equalToConstant: Constants.caloriesSize.width)
        ])
    }
}
