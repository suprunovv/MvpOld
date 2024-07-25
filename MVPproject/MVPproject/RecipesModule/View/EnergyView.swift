// EnergyView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Вью для описания энергетической ценности (жиры, белки, углеводы и каллории)
final class EnergyView: UIView {
    // MARK: - Constants

    /// Перечисление с еденицами измерения  отображаемых данных
    enum Unit: String {
        /// Каллории
        case calories = "kcal"
        /// Граммы
        case gram = "g"
    }

    enum TitleType: String {
        /// Каллории
        case enerckcal = "Enerc kcal"
        /// Углеводы
        case carbohydrates = "Carbohydrates"
        /// Жиры
        case fats = "Fats"
        /// Белки
        case proteins = "Proteins"
    }

    // MARK: - Visual components

    private var titelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .verdana(ofSize: 10)
        label.disableAutoresizingMask()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()

    private var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .greenAccent
        label.font = .verdana(ofSize: 10)
        label.textAlignment = .center
        label.disableAutoresizingMask()
        return label
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 15
        return view
    }()

    // MARK: - Initializators

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public methods

    func setupView(type: TitleType, value: Int) {
        titelLabel.text = type.rawValue
        var unit = Unit.calories
        switch type {
        case .enerckcal:
            unit = .calories
        default:
            unit = .gram
        }
        valueLabel.text = "\(value) \(unit.rawValue)"
    }

    // MARK: Private methods

    private func setView() {
        backgroundColor = .greenAccent
        layer.cornerRadius = 16
        heightAnchor.constraint(equalToConstant: 53).activate()
        setTitleLabelConstraint()
        setBottomViewConstraint()
        setValueLabelConstraint()
    }

    private func setTitleLabelConstraint() {
        addSubview(titelLabel)
        titelLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -2).activate()
        titelLabel.heightAnchor.constraint(equalToConstant: 14).activate()
        titelLabel.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        titelLabel.topAnchor.constraint(equalTo: topAnchor, constant: 9).activate()
    }

    private func setBottomViewConstraint() {
        addSubview(bottomView)
        bottomView.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        bottomView.heightAnchor.constraint(equalToConstant: 20).activate()
        bottomView.widthAnchor.constraint(equalTo: widthAnchor, constant: -4).activate()
        bottomView.topAnchor.constraint(equalTo: titelLabel.bottomAnchor, constant: 8).activate()
    }

    private func setValueLabelConstraint() {
        bottomView.addSubview(valueLabel)
        valueLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).activate()
        valueLabel.heightAnchor.constraint(equalToConstant: 15).activate()
        valueLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).activate()
        valueLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).activate()
    }
}
