// ProfileSettingCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка настройки в профиле
final class ProfileSettingCell: UITableViewCell {
    // MARK: - Constants

    static let reuseID = String(describing: ProfileSettingCell.self)

    // MARK: - Visual Components

    private let arrowImageView = UIImageView(image: .chevron)

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

    func configureCell(_ profileSetting: ProfileSettingOption) {
        var contentConfig = defaultContentConfiguration()
        contentConfig.attributedText = NSAttributedString(string: profileSetting.title, attributes: [
            .font: UIFont.verdana(ofSize: 18) ?? UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.grayText
        ])
        contentConfig.image = UIImage(named: profileSetting.iconImageName)
        contentConfiguration = contentConfig
    }

    // MARK: - Private Methods

    private func setupCell() {
        accessoryType = .disclosureIndicator
        accessoryView = arrowImageView
    }
}
