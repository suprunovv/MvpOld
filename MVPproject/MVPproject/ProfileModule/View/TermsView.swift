// TermsView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол делегата вьюшки политики исспользования
protocol TermsViewDelegate: AnyObject {
    /// Метод для закрытия вью
    func hideTermsView()
}

/// Вью с политикой
final class TermsView: UIView {
    // MARK: - Constants

    private enum Constants {
        static let titleText = "Terms of Use"
    }

    // MARK: - Visual components

    private let lineView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.backgroundColor = .grayHandle
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 20)
        label.textColor = .black
        label.text = Constants.titleText
        label.disableAutoresizingMask()
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.xMark, for: .normal)
        button.tintColor = .black
        button.disableAutoresizingMask()
        return button
    }()

    private let scrollView = UIScrollView()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = TermsDataSource.terms
        label.disableAutoresizingMask()
        return label
    }()

    // MARK: - Public properties

    weak var delegate: TermsViewDelegate?

    let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.disableAutoresizingMask()
        return view
    }()

    // MARK: - Initializators

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func setupView() {
        layer.cornerRadius = 30
        clipsToBounds = true
        backgroundColor = .white
        setHandleViewConstraints()
        setLineViewConstraints()
        setTitleLabelConstraints()
        setCloseButton()
        setupScrollView()
        setInfoLabel()
    }

    private func setHandleViewConstraints() {
        addSubview(handleView)
        handleView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        handleView.heightAnchor.constraint(equalToConstant: 34).activate()
        handleView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        handleView.topAnchor.constraint(equalTo: topAnchor).activate()
    }

    private func setLineViewConstraints() {
        handleView.addSubview(lineView)
        lineView.heightAnchor.constraint(equalToConstant: 5).activate()
        lineView.widthAnchor.constraint(equalToConstant: 50).activate()
        lineView.centerXAnchor.constraint(equalTo: handleView.centerXAnchor).activate()
        lineView.centerYAnchor.constraint(equalTo: handleView.centerYAnchor).activate()
    }

    private func setTitleLabelConstraints() {
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).activate()
        titleLabel.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 16).activate()
    }

    private func setCloseButton() {
        addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        closeButton.heightAnchor.constraint(equalToConstant: 14).activate()
        closeButton.widthAnchor.constraint(equalToConstant: 14).activate()
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).activate()
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).activate()
    }

    private func setupScrollView() {
        scrollView.disableAutoresizingMask()
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setInfoLabel() {
        scrollView.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            infoLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25),
            infoLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15),
            infoLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -50)
        ])
    }

    @objc private func tapCloseButton() {
        delegate?.hideTermsView()
    }
}
