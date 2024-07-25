// ModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import Swinject
import UIKit

/// Сборщик модуля авторизации
final class ModuleBuilder {
    private enum Constants {
        static let recipesTitle = "Recipes"
        static let favoritrsTitle = "Favorites"
        static let profileTitle = "Profile"
    }

    static func makeLoginModule(coordinator: AuthCoordinator) -> UIViewController {
        let viewController = LoginViewController()
        let presenter = LoginPresenter(view: viewController, coordinator: coordinator)
        viewController.presenter = presenter
        return viewController
    }

    static func makeMapModule(coordinator: ProfileCoordinator) -> UIViewController {
        let viewController = MapViewController()
        let presenter = MapViewPresenter(view: viewController, coordinator: coordinator)
        viewController.presenter = presenter
        return viewController
    }

    static func makeRecipesModule(coordinator: RecipesCoordinator) -> UIViewController {
        let viewController = RecipesViewController()
        let recipesPresenter = RecipesPresenter(view: viewController, coordinator: coordinator)
        viewController.presenter = recipesPresenter
        viewController.tabBarItem = UITabBarItem(
            title: Constants.recipesTitle,
            image: .cakeBarIcon,
            selectedImage: .cakeFullBarIcon
        )
        return viewController
    }

    static func makeFavoritesModule(coordinator: FavoritesCoordinator) -> UIViewController {
        let viewController = FavoritesViewController()
        let favoritesPresenter = FavoritesPresenter(view: viewController, coordinator: coordinator)
        viewController.presenter = favoritesPresenter
        viewController.tabBarItem = UITabBarItem(
            title: Constants.favoritrsTitle,
            image: .bookmarkBarIcon,
            selectedImage: .bookmarkFullBarIcon
        )
        return viewController
    }

    static func makeProfileModule(coordinator: ProfileCoordinator) -> UIViewController {
        let viewController = ProfileViewController()
        let profilePresenter = ProfilePresenter(view: viewController, coordinator: coordinator)
        viewController.presenter = profilePresenter
        viewController.tabBarItem = UITabBarItem(
            title: Constants.profileTitle,
            image: .profileBarIcon,
            selectedImage: .profileFullBarIcon
        )
        return viewController
    }

    static func makeCategoryModule(coordinator: RecipesCoordinator, category: RecipesCategory) -> UIViewController {
        let viewController = CategoryViewController()
        let container = SceneDelegate.setContainer()
        let presenter = CategoryPresenter(
            view: viewController,
            coordinator: coordinator,
            networkService: container.resolve(NetworkService.self),
            category: category,
            loadImageService: container.resolve(LoadImageProxy.self)
        )
        viewController.presenter = presenter
        return viewController
    }

    static func makeBonusesModule(coordinator: ProfileCoordinator) -> UIViewController {
        let viewController = BonusesViewController()
        let bonusesPresenter = BonusesPresenter(view: viewController, coordinator: coordinator)
        viewController.presenter = bonusesPresenter

        return viewController
    }

    static func makeDetailModule(
        coordinator: RecipeWithDetailsCoordinatorProtocol,
        recipe: Recipe
    ) -> UIViewController {
        let container = SceneDelegate.setContainer()
        let viewController = DetailViewController()
        let presenter = DetailPresenter(
            view: viewController,
            coordinator: coordinator,
            networkService: container.resolve(NetworkService.self),
            recipe: recipe,
            loadImageService: container.resolve(LoadImageProxy.self)
        )
        viewController.presenter = presenter
        return viewController
    }
}
