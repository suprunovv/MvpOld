// RecipelyAppTabBarController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Таббар приложения
final class RecipelyAppTabBarController: UITabBarController {
    // MARK: - Constants

    enum Constants {
        static let borderToScreenSpacing = 8.0
    }

    // MARK: - Visual Components

    private let topBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .greenBgAccent
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    // MARK: - Private Methods

    private func setupTabBar() {
        setupAppearance()
        setupBorderTop()
    }

    private func setupAppearance() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBar.appearance().tintColor = .greenAccent
        UITabBarItem.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor.greenAccent
        ], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([
            .font: UIFont.verdana(ofSize: 10) ?? UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.grayText
        ], for: .normal)
    }

    private func setupBorderTop() {
        tabBar.addSubview(topBorderView)
        NSLayoutConstraint.activate([
            topBorderView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            topBorderView.leadingAnchor.constraint(
                equalTo: tabBar.leadingAnchor,
                constant: Constants.borderToScreenSpacing
            ),
            topBorderView.trailingAnchor.constraint(
                equalTo: tabBar.trailingAnchor,
                constant: -Constants.borderToScreenSpacing
            )
        ])
    }
}
