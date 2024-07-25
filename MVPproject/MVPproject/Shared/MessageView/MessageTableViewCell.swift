// MessageTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка сообщений
final class MessageTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let reuseID = String(describing: MessageTableViewCell.self)

    // MARK: - Visual Components

    private let messageView = MessageView()

    // MARK: - Public Properties

    weak var delegate: MessageViewDelegate? {
        didSet {
            messageView.delegate = delegate
        }
    }

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public Methods

    func configureCell(messageViewConfig: MessageViewConfig) {
        messageView.updateUI(config: messageViewConfig)
    }

    // MARK: - Private Methods

    private func setupCell() {
        contentView.addSubview(messageView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            messageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            contentView.trailingAnchor.constraint(
                equalTo: messageView.trailingAnchor
            )
        ])
    }
}
