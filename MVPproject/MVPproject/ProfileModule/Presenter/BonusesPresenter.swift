// BonusesPresenter.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол презентера экрана бонусов
protocol BonusesPresenterProtocol: AnyObject {
    /// Обновление данных о бонусах
    func refreshBonusesData()
}

/// Презентер экрана бонусов
final class BonusesPresenter {
    private weak var coordinator: ProfileCoordinator?
    private weak var view: BonusesViewProtocol?

    init(view: BonusesViewController, coordinator: ProfileCoordinator) {
        self.view = view
        self.coordinator = coordinator
        refreshBonusesData()
    }
}

// MARK: - BonusesPresenter + BonusesPresenterProtocol

extension BonusesPresenter: BonusesPresenterProtocol {
    func refreshBonusesData() {
        let bonusesCount = ProfileConfiguration.shared.profileInfo.bonusesCount
        view?.updateBonusesCount(bonusesCount)
    }
}
