// AppCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Главный координатор приложения опредляющий флоу Auth или Main
final class AppCoordinator: BaseCoordinator {
    /// Перечисление экранов таббара
    enum TabBarScreen: Int {
        /// Экран рецептов
        case recipes = 0
        /// Экран избранных
        case favorites = 1
        /// Экран профиля
        case profile = 2
    }

    override func start() {
        switch AuthService.shared.state {
        case .unauthorized:
            toAuth()
        case .loggedIn:
            toMain()
        }
    }

    private func toMain() {
        let tabBarCoordinator = AppTabBarCoordinator()
        add(coordinator: tabBarCoordinator)
        tabBarCoordinator.start()
    }

    private func toAuth() {
        let authCoordinator = AuthCoordinator()
        authCoordinator.finishFlowHandler = { [weak self] in
            self?.remove(coordinator: authCoordinator)
            self?.toMain()
        }
        add(coordinator: authCoordinator)
        authCoordinator.start()
    }

    func toScreen(_ screen: TabBarScreen) {
        let tabBarCoordinator = AppTabBarCoordinator()
        add(coordinator: tabBarCoordinator)
        tabBarCoordinator.start()
        tabBarCoordinator.openTo(index: screen.rawValue)
    }

    func changeUserName(to: String) {
        let tabBarCoordinator = AppTabBarCoordinator()
        add(coordinator: tabBarCoordinator)
        tabBarCoordinator.start()
        tabBarCoordinator.set(userName: to)
    }
}
