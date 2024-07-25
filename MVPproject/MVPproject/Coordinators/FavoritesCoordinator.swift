// FavoritesCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Координатор избранных рецептов
final class FavoritesCoordinator: BaseCoordinator, RecipeWithDetailsCoordinatorProtocol {
    private(set) var navigationController: UINavigationController?

    override func start() {
        guard let favoritesModuleView = ModuleBuilder
            .makeFavoritesModule(coordinator: self) as? FavoritesViewController else { return }
        navigationController = UINavigationController(rootViewController: favoritesModuleView)
    }
}
