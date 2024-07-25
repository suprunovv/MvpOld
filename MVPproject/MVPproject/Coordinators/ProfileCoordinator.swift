// ProfileCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Координатор профиля
final class ProfileCoordinator: BaseCoordinator {
    private(set) var navigationController: UINavigationController?
    private var termsView: TermsView?

    override func start() {
        guard let profileModuleView = ModuleBuilder.makeProfileModule(coordinator: self) as? ProfileViewController
        else { return }
        navigationController = UINavigationController(rootViewController: profileModuleView)
    }

    func showBonuses() {
        guard let bonusesModuleView = ModuleBuilder.makeBonusesModule(
            coordinator: self
        ) as? BonusesViewController else { return }
        if let sheet = bonusesModuleView.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
        navigationController?.present(bonusesModuleView, animated: true)
    }

    func showTerms() {
        guard let profileViewController = navigationController?.topViewController as? ProfileViewController
        else { return }
        let termsView = TermsView()
        self.termsView = termsView
        navigationController?.tabBarController?.tabBar.isHidden = true
        navigationController?.tabBarController?.view.addSubview(termsView)
        profileViewController.presenter?.presentTerms(termsView)
    }

    func showMap() {
        let mapView = ModuleBuilder.makeMapModule(coordinator: self)
        mapView.modalPresentationStyle = .fullScreen
        navigationController?.present(mapView, animated: true)
    }

    func hideTerms() {
        navigationController?.tabBarController?.tabBar.isHidden = false
        termsView?.removeFromSuperview()
        termsView = nil
    }
}
