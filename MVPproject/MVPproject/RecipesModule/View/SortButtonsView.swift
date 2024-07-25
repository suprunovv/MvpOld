// SortButtonsView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол для делегата SortButtonsView
protocol SortButtonViewDelegate: AnyObject {
    /// Обновление состояния сортировки по времени
    func updateTimeSorting(_ sorting: SortingButton.SortState)
    /// Обновление состояния сортировки по калориям
    func updateCaloriesSorting(_ sorting: SortingButton.SortState)
}

/// Вью с 2мя кнопками сортировки
final class SortButtonsView: UIView {
    // MARK: - Visual components

    private let caloriesButton: SortingButton = {
        let button = SortingButton()
        button.setTitle(SwiftGenStrings.SortButtonView.calloriesTitle, for: .normal)
        return button
    }()

    private let timeButton: SortingButton = {
        let button = SortingButton()
        button.setTitle(SwiftGenStrings.SortButtonView.timeTitle, for: .normal)
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [caloriesButton, timeButton])
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = 11
        stack.disableAutoresizingMask()
        return stack
    }()

    // MARK: - Public properties

    weak var delegate: SortButtonViewDelegate?

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
        timeButton.delegate = self
        caloriesButton.delegate = self
        disableAutoresizingMask()
        addSubview(buttonsStackView)
        setButtonsStackConstaints()
    }

    private func setButtonsStackConstaints() {
        buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        buttonsStackView.topAnchor.constraint(equalTo: topAnchor).activate()
    }
}

// MARK: - SortButtonsView + SortingButtonDelegate

extension SortButtonsView: SortingButtonDelegate {
    func sortingDidChange(_ button: UIButton, sorting: SortingButton.SortState) {
        switch button {
        case timeButton:
            delegate?.updateTimeSorting(sorting)
        case caloriesButton:
            delegate?.updateCaloriesSorting(sorting)
        default:
            break
        }
    }
}
