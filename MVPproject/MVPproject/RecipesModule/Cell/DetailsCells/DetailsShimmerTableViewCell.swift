// DetailsShimmerTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка заглушка для индикатора загрузки деталей рецепта
final class DetailsShimmerTableViewCell: UITableViewCell {
    // MARK: - Constants

    private enum Constants {
        static let imagePlaceholderSize = 300.0
        static let imagePlaceholderCornerRadius = 24.0
        static let labelPlaceholderHeight = 16.0
        static let nutrientViewSize = CGSize(width: 74, height: 53)
        static let nutrientViewCornerRadius = 16.0
        static let recipeViewCornerRadius = 24.0
        static let nutrientsSpacing = 5.0
        static let recipeStepToStepSpacing = 20.0
        static let recipeStepsSpacing = 27.0
    }

    static let reuseID = String(describing: DetailsShimmerTableViewCell.self)

    // MARK: - Visual Components

    private let imagePlaceholderView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.layer.cornerRadius = Constants.imagePlaceholderCornerRadius
        view.clipsToBounds = true
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: Constants.imagePlaceholderSize),
            view.widthAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }()

    private lazy var recipeNamePlaceholderView = makeLabelPlaceholderView()

    private let recipeStepsPlaceholderView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = Constants.recipeViewCornerRadius
        view.backgroundColor = .blueRecipeBg
        return view
    }()

    private lazy var recipeStepsStackView: UIStackView = {
        let stack = UIStackView()
        for _ in 1 ... 5 {
            stack.addArrangedSubview(makeLabelPlaceholderView())
        }
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = Constants.recipeStepToStepSpacing
        stack.disableAutoresizingMask()
        return stack
    }()

    private lazy var nutrientsStackView: UIStackView = {
        let stack = UIStackView()
        for _ in 1 ... 4 {
            stack.addArrangedSubview(makeNutrientView())
        }
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = Constants.nutrientsSpacing
        stack.disableAutoresizingMask()
        return stack
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        let shimmeredViews: [UIView] = [
            recipeNamePlaceholderView,
            imagePlaceholderView
        ] + nutrientsStackView.arrangedSubviews + recipeStepsStackView.arrangedSubviews
        for view in shimmeredViews {
            view.layoutIfNeeded()
            let shimmerLayer = ShimmerLayer(clearColor: .white)
            view.layer.addSublayer(shimmerLayer)
            shimmerLayer.frame = view.bounds
        }
    }

    // MARK: - Private Methods

    private func setupView() {
        backgroundColor = .white
        disableAutoresizingMask()
        contentView.addSubviews(
            recipeNamePlaceholderView,
            imagePlaceholderView,
            recipeStepsPlaceholderView,
            nutrientsStackView
        )
        recipeStepsPlaceholderView.addSubview(recipeStepsStackView)
        setupNamePlaceholderViewConstraints()
        setupImagePlaceholderViewConstraints()
        setupNutrientsStackConstraints()
        setupRecipeStepsConstraints()
    }

    private func setupNamePlaceholderViewConstraints() {
        NSLayoutConstraint.activate([
            recipeNamePlaceholderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeNamePlaceholderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            contentView.trailingAnchor.constraint(equalTo: recipeNamePlaceholderView.trailingAnchor, constant: 20.0)
        ])
    }

    private func setupImagePlaceholderViewConstraints() {
        imagePlaceholderView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            imagePlaceholderView.topAnchor.constraint(equalTo: recipeNamePlaceholderView.bottomAnchor, constant: 20.0),
            imagePlaceholderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    private func setupNutrientsStackConstraints() {
        NSLayoutConstraint.activate([
            nutrientsStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nutrientsStackView.topAnchor.constraint(equalTo: imagePlaceholderView.bottomAnchor, constant: 20.0)
        ])
    }

    private func setupRecipeStepsConstraints() {
        recipeNamePlaceholderView.setContentHuggingPriority(.defaultLow, for: .vertical)
        recipeStepsStackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            recipeStepsPlaceholderView.topAnchor.constraint(equalTo: nutrientsStackView.bottomAnchor, constant: 20.0),
            recipeStepsPlaceholderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeStepsPlaceholderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeStepsPlaceholderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            recipeStepsStackView.topAnchor.constraint(
                equalTo: recipeStepsPlaceholderView.topAnchor,
                constant: Constants.recipeStepsSpacing
            ),
            recipeStepsPlaceholderView.trailingAnchor.constraint(
                equalTo: recipeStepsStackView.trailingAnchor,
                constant: Constants.recipeStepsSpacing
            ),
            recipeStepsStackView.leadingAnchor.constraint(
                equalTo: recipeStepsPlaceholderView.leadingAnchor,
                constant: Constants.recipeStepsSpacing
            )
        ])
        let stepsHeightConstraint = recipeStepsPlaceholderView.bottomAnchor.constraint(
            equalTo: recipeStepsStackView.bottomAnchor,
            constant: Constants.recipeStepsSpacing
        )
        stepsHeightConstraint.priority = .defaultLow
    }

    private func makeNutrientView() -> UIView {
        let view = UIView()
        view.disableAutoresizingMask()
        view.layer.cornerRadius = Constants.nutrientViewCornerRadius
        view.clipsToBounds = true
        view.backgroundColor = .red
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: Constants.nutrientViewSize.height),
            view.widthAnchor.constraint(equalToConstant: Constants.nutrientViewSize.width)
        ])
        return view
    }

    private func makeLabelPlaceholderView() -> UIView {
        let view = UIView()
        view.disableAutoresizingMask()
        view.heightAnchor.constraint(equalToConstant: Constants.labelPlaceholderHeight).activate()
        return view
    }
}
