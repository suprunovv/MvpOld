// FullRecipeTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с полным описанием готовки блюда
final class FullRecipeTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let reuseID = String(describing: FullRecipeTableViewCell.self)

    // MARK: - Visual components

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 14)
        label.textColor = .black
        label.disableAutoresizingMask()
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Initializators

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLabelConstraints()
        setCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public methods

    func setupDescription(text: String?) {
        guard let text = text else {
            return
        }
        descriptionLabel.text = text
    }

    // MARK: - Private methods

    private func setLabelConstraints() {
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 27),
            contentView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 27),
            contentView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 27)
        ])
    }

    private func setCell() {
        backgroundColor = .blueRecipeBg
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 24
    }
}
