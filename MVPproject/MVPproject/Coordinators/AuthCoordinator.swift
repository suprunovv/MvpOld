// AuthCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Координатор авторизации
final class AuthCoordinator: BaseCoordinator {
    var finishFlowHandler: VoidHandler?
    private var navigationController: UINavigationController?

    override func start() {
        guard let authModuleView = ModuleBuilder.makeLoginModule(coordinator: self) as? LoginViewController
        else { return }
        navigationController = UINavigationController(rootViewController: authModuleView)
        if let navigationController = navigationController {
            setAsRoot(navigationController)
        }
    }

    func didLogin() {
        finishFlowHandler?()
    }
}
