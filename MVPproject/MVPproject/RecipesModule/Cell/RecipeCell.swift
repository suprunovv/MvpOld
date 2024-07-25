// RecipeCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка рецепта
class RecipeCell: UITableViewCell {
    // MARK: - Constants

    private enum Constants {
        static let panelCornerRadius = 12.0
        static let recipeImageCornerRadius = 12.0
        static let infoIconSize = 15.0
        static let recipeImageSize = 80.0
        static let chevronSize = 20.0
        static let recipeStackSpacing = 20.0
        static let infoIconToLabelSpacing = 4.0
        static let infoSpacing = 20.0
        static let infoStackHeight = 56.0
        static let cellInnerSpacing = 10.0
        static let cellOuterSpacing = (x: 20.0, y: 7.0)
        static let timeInfoText = "min"
        static let caloriesInfoText = "kkal"
        static let recipeNameLabelSize = CGSize(width: 197, height: 32)
        static let cookingTimeSize = CGSize(width: 74, height: 15)
        static let caloriesSize = CGSize(width: 91, height: 15)
    }

    static var reuseID: String { String(describing: RecipeCell.self) }

    // MARK: - Visual Components

    private(set) var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.recipeImageCornerRadius
        imageView.clipsToBounds = true
        imageView.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.recipeImageSize),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        return imageView
    }()

    private(set) var recipeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 14)
        label.numberOfLines = 0
        label.disableAutoresizingMask()
        return label
    }()

    private(set) var chevronImageView: UIImageView = {
        let imageView = UIImageView(image: .chevronBold)
        imageView.contentMode = .center
        imageView.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.chevronSize),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        return imageView
    }()

    private let recipeView: UIView = {
        let view = UIView()
        view.backgroundColor = .greenBgAccent
        view.layer.cornerRadius = Constants.panelCornerRadius
        view.disableAutoresizingMask()
        return view
    }()

    private let cookingTimeLabel = UILabel()
    private let caloriesLabel = UILabel()

    private(set) lazy var cookingTimeStackView = makeInfoStack(label: cookingTimeLabel, image: .timer)
    private(set) lazy var caloriesStackView = makeInfoStack(label: caloriesLabel, image: .pizza)

    private lazy var infoStackView: UIStackView = {
        let infoStack = UIStackView(arrangedSubviews: [cookingTimeStackView, caloriesStackView])
        infoStack.spacing = Constants.infoSpacing
        infoStack.alignment = .leading
        let stack = UIStackView(arrangedSubviews: [recipeNameLabel, infoStack])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.disableAutoresizingMask()
        stack.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.infoStackHeight).activate()
        return stack
    }()

    private lazy var recipeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [recipeImageView, infoStackView, chevronImageView])
        stack.spacing = Constants.recipeStackSpacing
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.disableAutoresizingMask()
        return stack
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    // MARK: - Public Methods

    func configure(withRecipe recipe: Recipe) {
        recipeNameLabel.text = recipe.name
        cookingTimeLabel.text = "\(recipe.cookingTime) \(Constants.timeInfoText)"
        caloriesLabel.text = "\(recipe.calories) \(Constants.caloriesInfoText)"
    }

    func setImage(_ imageData: Data) {
        recipeImageView.image = UIImage(data: imageData)
    }

    // MARK: - Private Methods

    private func setupCell() {
        selectionStyle = .none
        recipeView.addSubview(recipeStackView)
        contentView.addSubview(recipeView)
        setupConstraints()
    }

    private func setupConstraints() {
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

            recipeStackView.topAnchor.constraint(equalTo: recipeView.topAnchor, constant: Constants.cellInnerSpacing),
            recipeStackView.leadingAnchor.constraint(
                equalTo: recipeView.leadingAnchor,
                constant: Constants.cellInnerSpacing
            ),
            recipeView.trailingAnchor.constraint(
                equalTo: recipeStackView.trailingAnchor,
                constant: Constants.cellInnerSpacing
            ),
            recipeView.bottomAnchor.constraint(
                equalTo: recipeStackView.bottomAnchor,
                constant: Constants.cellInnerSpacing
            ),
        ])
    }

    private func makeInfoStack(label: UILabel, image: UIImage?) -> UIStackView {
        let imageView = UIImageView(image: image)
        imageView.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.infoIconSize),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        label.font = .verdana(ofSize: 12)
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.spacing = Constants.infoIconToLabelSpacing
        stack.alignment = .leading
        stack.disableAutoresizingMask()
        return stack
    }
}
