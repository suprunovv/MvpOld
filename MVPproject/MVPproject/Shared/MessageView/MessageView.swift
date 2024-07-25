// MessageView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол делегата сообщения
protocol MessageViewDelegate: AnyObject {
    /// Метод перезагрузки
    func reload()
}

/// Плашка-сообщение
final class MessageView: UIView {
    // MARK: - Constants

    private enum Constants {
        static let iconSize = 50.0
        static let stackSpacing = 17.0
        static let reloadButtonCornerRadius = 12.0
        static let reloadButtonSize = CGSize(width: 150, height: 32)
        static let reloadButtonText = "Reload"
    }

    // MARK: - Visual Components

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 14)
        label.textColor = .grayTextSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var reloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = Constants.reloadButtonCornerRadius
        button.setImage(.reload, for: .normal)
        button.backgroundColor = .blueLight
        button.setTitle(Constants.reloadButtonText, for: .normal)
        button.titleLabel?.font = .verdana(ofSize: 14)
        button.titleLabel?.textColor = .grayTextSecondary
        button.tintColor = .grayTextSecondary
        button.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.reloadButtonSize.width),
            button.heightAnchor.constraint(equalToConstant: Constants.reloadButtonSize.height)
        ])
        button.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
        return button
    }()

    private let messageStackView: UIStackView = {
        let stack = UIStackView()
        stack.disableAutoresizingMask()
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .center
        return stack
    }()

    // MARK: - Public Properties

    weak var delegate: MessageViewDelegate?

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        setupView()
    }

    init(config: MessageViewConfig) {
        super.init(frame: .zero)
        setupView()
        configureUI(config: config)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Public Methods

    func updateUI(config: MessageViewConfig) {
        configureUI(config: config)
    }

    // MARK: - Private Methods

    private func setupView() {
        backgroundColor = .white
        disableAutoresizingMask()
        addSubview(messageStackView)
        messageStackView.addArrangedSubview(iconImageView)
        messageStackView.addArrangedSubview(titleLabel)
        messageStackView.addArrangedSubview(descriptionLabel)
        messageStackView.addArrangedSubview(reloadButton)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messageStackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            messageStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 20
            ),
            safeAreaLayoutGuide.trailingAnchor.constraint(
                equalTo: messageStackView.trailingAnchor,
                constant: 20
            )
        ])
    }

    private func configureUI(config: MessageViewConfig) {
        iconImageView.image = config.icon
        descriptionLabel.text = config.description
        titleLabel.text = config.title
        titleLabel.isHidden = config.title == nil
        reloadButton.isHidden = !config.withReload
    }

    @objc private func reloadButtonTapped() {
        delegate?.reload()
    }
}
