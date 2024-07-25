// ProfileInfoCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// протокол обработки событий в ячейке ProfileInfo
protocol ProfileInfoCellDelegate: AnyObject {
    func editNameButtonTapped()
    /// Открытие галереи
    func openGalery()
}

/// Ячейка информации о профиле
final class ProfileInfoCell: UITableViewCell {
    // MARK: - Constants

    private enum Constants {
        static let avatarImageSize = 160.0
        static let avatarImageCornerRadius = avatarImageSize / 2
        static let avatarImageBorderWidth = 3.0
        static let profileToCellTopSpacing = 36.0
        static let profileToCellBottomSpacing = 29.0
        static let fullNameToAvatarSpacing = 26.0
        static let fullNameToEditButtonSpacing = 8.0
        static let profileToViewWidthDifference = 100.0
        static let defaultAvatarImageName = "profileAvatar"
    }

    static let reuseID = String(describing: ProfileInfoCell.self)

    // MARK: - Visual Components

    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = Constants.avatarImageCornerRadius
        view.layer.borderWidth = Constants.avatarImageBorderWidth
        view.layer.borderColor = UIColor.greenAccent.cgColor
        view.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: Constants.avatarImageSize),
            view.heightAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 25)
        label.textColor = .grayText
        label.disableAutoresizingMask()
        return label
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.pencil, for: .normal)
        button.tintColor = .grayText
        button.disableAutoresizingMask()
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var profileStackView: UIStackView = {
        let nameStack = UIStackView(arrangedSubviews: [fullNameLabel, editButton])
        nameStack.axis = .horizontal
        nameStack.alignment = .center
        nameStack.spacing = Constants.fullNameToEditButtonSpacing
        let profileStack = UIStackView(arrangedSubviews: [profileImageView, nameStack])
        profileStack.axis = .vertical
        profileStack.spacing = Constants.fullNameToAvatarSpacing
        profileStack.alignment = .center
        profileStack.disableAutoresizingMask()
        return profileStack
    }()

    // MARK: - Public Properties

    weak var delegate: ProfileInfoCellDelegate?

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

    func configureCell(_ profileInfo: ProfileInfo) {
        if let imageData = profileInfo.avatarImageData {
            let image = UIImage(data: imageData)
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(named: Constants.defaultAvatarImageName)
        }
        fullNameLabel.text = profileInfo.fullName
    }

    // MARK: - Private Methods

    private func setupCell() {
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        contentView.addSubview(profileStackView)

        setupProfileStackViewConstraints()
        addProfileImageGesture()
    }

    private func setupProfileStackViewConstraints() {
        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.profileToCellTopSpacing
            ),
            profileStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentView.widthAnchor.constraint(
                equalTo: profileStackView.widthAnchor,
                constant: Constants.profileToViewWidthDifference
            ),
            contentView.bottomAnchor.constraint(
                equalTo: profileStackView.bottomAnchor,
                constant: Constants.profileToCellBottomSpacing
            )
        ])
    }

    private func addProfileImageGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(registerTupImageView))
        profileImageView.addGestureRecognizer(gesture)
    }

    @objc private func editButtonTapped() {
        delegate?.editNameButtonTapped()
    }

    @objc private func registerTupImageView() {
        delegate?.openGalery()
    }
}
