// SortingButton.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол  делегата контрола сортировки
protocol SortingButtonDelegate: AnyObject {
    /// Обновление сортировки на следующее состояние
    func sortingDidChange(_ button: UIButton, sorting: SortingButton.SortState)
}

/// Кнопка сортировки
final class SortingButton: UIButton {
    // MARK: - Constants

    /// Перечисление состояний кнопок
    enum SortState {
        /// сортировка отключена
        case unsorted
        /// сортировка по возрастанию
        case ascending
        /// сортировка по убыванию
        case descending

        mutating func toggleSort() {
            switch self {
            case .unsorted:
                self = .descending
            case .ascending:
                self = .unsorted
            case .descending:
                self = .ascending
            }
        }
    }

    private enum Constants {
        static let imageToLabelSpacing = 4.0
    }

    // MARK: - Public Properties

    weak var delegate: SortingButtonDelegate?

    // MARK: - Private Properties

    private var sortState: SortState = .unsorted {
        didSet {
            setNeedsUpdateConfiguration()
            setImage(sortState == .ascending ? .stackDown : .stackUp, for: .normal)
            tintColor = isActive ? .white : .black
        }
    }

    private var isActive: Bool {
        sortState != .unsorted
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupControl()
    }

    // MARK: - Private Methods

    private func setupControl() {
        setImage(.stackUp, for: .normal)
        configuration = UIButton.Configuration.filled()
        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
            var transformedString = $0
            transformedString.font = UIFont.verdana(ofSize: 16)
            return transformedString
        }
        configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            var config = button.configuration
            config?.baseForegroundColor = self.isActive ? .white : .black
            config?.baseBackgroundColor = self.isActive ? .greenAccent : .greenBgAccent
            button.configuration = config
        }
        configuration?.cornerStyle = .capsule
        configuration?.imagePlacement = .trailing
        configuration?.imagePadding = Constants.imageToLabelSpacing

        addTarget(self, action: #selector(toggleState), for: .touchUpInside)
    }

    @objc private func toggleState() {
        sortState.toggleSort()
        delegate?.sortingDidChange(self, sorting: sortState)
    }
}
