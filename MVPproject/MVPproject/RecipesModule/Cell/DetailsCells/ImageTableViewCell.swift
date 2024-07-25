// ImageTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с фото готового блюда
final class ImageTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let reuseID = String(describing: ImageTableViewCell.self)

    private enum Constants {
        static let cookingTime = "Cooking time"
        static let min = "min"
        static let gram = "g"
        static let imageSize = 300.0
    }

    // MARK: - Visual components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.font = .verdanaBold(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.disableAutoresizingMask()
        imageView.layer.cornerRadius = 43
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()

    private let portionSizeView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.backgroundColor = .greenAlpha
        view.layer.cornerRadius = 25
        return view
    }()

    private let portionSizeLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.font = .verdana(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    private let portionSizeImageView: UIImageView = {
        let imageView = UIImageView(image: .pot)
        imageView.disableAutoresizingMask()
        imageView.tintColor = .white
        return imageView
    }()

    private let cookingTimeView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.backgroundColor = .greenAlpha
        view.layer.cornerRadius = 24
        return view
    }()

    private let cookingTimeImageView: UIImageView = {
        let imageView = UIImageView(image: .timerPdf)
        imageView.disableAutoresizingMask()
        imageView.tintColor = .white
        return imageView
    }()

    private let cookingTimeLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.numberOfLines = 0
        label.font = .verdana(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    // MARK: - Initializators

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public methods

    func configureCell(recipe: Recipe?) {
        guard let recipe = recipe else { return }
        cookingTimeLabel.text = "\(Constants.cookingTime)\n \(recipe.cookingTime) \(Constants.min)"
        portionSizeLabel.text = "\(recipe.details?.weight ?? 0) \(Constants.gram)"
        titleLabel.text = recipe.name
    }

    func setImage(_ imageData: Data) {
        titleImageView.image = UIImage(data: imageData)
    }

    // MARK: - Private methods

    private func setupCell() {
        setTitleLabelConstraint()
        setImageViewConstraints()
        setRightViewConstraint()
        setRightImageViewConstraint()
        setRightLabelConstraint()
        setBottomViewConstraint()
        setBottomImageViewConsraint()
        setBottomLabelConstraint()
    }

    private func setImageViewConstraints() {
        contentView.addSubview(titleImageView)
        NSLayoutConstraint.activate([
            titleImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            titleImageView.heightAnchor.constraint(equalTo: titleImageView.widthAnchor),
            titleImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            titleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setRightViewConstraint() {
        titleImageView.addSubview(portionSizeView)
        portionSizeView.widthAnchor.constraint(equalToConstant: 50).activate()
        portionSizeView.heightAnchor.constraint(equalToConstant: 50).activate()
        portionSizeView.topAnchor.constraint(equalTo: titleImageView.topAnchor, constant: 8).activate()
        portionSizeView.trailingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: -10).activate()
    }

    private func setTitleLabelConstraint() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20)
        ])
    }

    private func setRightImageViewConstraint() {
        addSubview(portionSizeImageView)
        portionSizeImageView.widthAnchor.constraint(equalToConstant: 20).activate()
        portionSizeImageView.heightAnchor.constraint(equalToConstant: 17).activate()
        portionSizeImageView.centerXAnchor.constraint(equalTo: portionSizeView.centerXAnchor).activate()
        portionSizeImageView.topAnchor.constraint(equalTo: portionSizeView.topAnchor, constant: 7).activate()
    }

    private func setRightLabelConstraint() {
        portionSizeView.addSubview(portionSizeLabel)
        portionSizeLabel.widthAnchor.constraint(equalToConstant: 39).activate()
        portionSizeLabel.heightAnchor.constraint(equalToConstant: 15).activate()
        portionSizeLabel.centerXAnchor.constraint(equalTo: portionSizeView.centerXAnchor).activate()
        portionSizeLabel.topAnchor.constraint(equalTo: portionSizeImageView.bottomAnchor, constant: 6).activate()
    }

    private func setBottomViewConstraint() {
        titleImageView.addSubview(cookingTimeView)
        cookingTimeView.widthAnchor.constraint(equalToConstant: 154).activate()
        cookingTimeView.heightAnchor.constraint(equalToConstant: 48).activate()
        cookingTimeView.leadingAnchor.constraint(equalTo: titleImageView.leadingAnchor, constant: 176).activate()
        cookingTimeView.bottomAnchor.constraint(equalTo: titleImageView.bottomAnchor).activate()
    }

    private func setBottomImageViewConsraint() {
        cookingTimeView.addSubview(cookingTimeImageView)
        cookingTimeImageView.widthAnchor.constraint(equalToConstant: 25).activate()
        cookingTimeImageView.heightAnchor.constraint(equalToConstant: 25).activate()
        cookingTimeImageView.centerYAnchor.constraint(equalTo: cookingTimeView.centerYAnchor).activate()
        cookingTimeImageView.leadingAnchor.constraint(equalTo: cookingTimeView.leadingAnchor, constant: 8).activate()
    }

    private func setBottomLabelConstraint() {
        cookingTimeView.addSubview(cookingTimeLabel)
        cookingTimeLabel.widthAnchor.constraint(equalToConstant: 83).activate()
        cookingTimeLabel.heightAnchor.constraint(equalToConstant: 30).activate()
        cookingTimeLabel.centerYAnchor.constraint(equalTo: cookingTimeView.centerYAnchor).activate()
        cookingTimeLabel.leadingAnchor.constraint(equalTo: cookingTimeImageView.trailingAnchor).activate()
    }
}
