// AppTabBarCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Координатор таббара
final class AppTabBarCoordinator: BaseCoordinator {
    private var recipelyAppTabBarController: RecipelyAppTabBarController?

    override func start() {
        recipelyAppTabBarController = RecipelyAppTabBarController()
        /// Set Recipes
        let recipesCoordinator = RecipesCoordinator()
        recipesCoordinator.start()
        add(coordinator: recipesCoordinator)

        /// Set Favorites
        let favoritesCoordinator = FavoritesCoordinator()
        favoritesCoordinator.start()
        add(coordinator: favoritesCoordinator)

        /// Set Profile
        let profileCoordinator = ProfileCoordinator()
        profileCoordinator.start()
        add(coordinator: profileCoordinator)

        recipelyAppTabBarController?.setViewControllers(
            [
                recipesCoordinator.navigationController,
                favoritesCoordinator.navigationController,
                profileCoordinator.navigationController
            ].compactMap { $0 },
            animated: false
        )

        if let tabBarViewController = recipelyAppTabBarController {
            setAsRoot(tabBarViewController)
        }
    }

    func openTo(index: Int) {
        recipelyAppTabBarController?.selectedIndex = index
    }

    func set(userName: String) {
        recipelyAppTabBarController?.selectedIndex = 2
        guard let navigationController = recipelyAppTabBarController?.children[2] as? UINavigationController,
              let profileViewController = navigationController.topViewController as? ProfileViewController,
              let profilePresenter = profileViewController.presenter else { return }
        profilePresenter.handleNameChanged(userName)
    }
}
