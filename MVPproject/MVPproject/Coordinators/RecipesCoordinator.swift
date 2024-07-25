// RecipesCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол координатора рецептов с деталями
protocol RecipeWithDetailsCoordinatorProtocol: AnyObject {
    /// Навигация  координаторе
    var navigationController: UINavigationController? { get }
    /// Открыть детали о рецепте
    func showDetails(recipe: Recipe)
    /// Закрыть детали о рецепте
    func closeDetails()
}

/// Расширение с дефолтной реализацией протокола
extension RecipeWithDetailsCoordinatorProtocol {
    func closeDetails() {
        guard (navigationController?.viewControllers.last as? DetailViewController) != nil else {
            return
        }
        navigationController?.popViewController(animated: true)
    }

    func showDetails(recipe: Recipe) {
        guard let detailModule = ModuleBuilder
            .makeDetailModule(coordinator: self, recipe: recipe) as? DetailViewController else { return }
        navigationController?.pushViewController(detailModule, animated: true)
    }
}

/// Координатор рецептов
final class RecipesCoordinator: BaseCoordinator, RecipeWithDetailsCoordinatorProtocol {
    private(set) var navigationController: UINavigationController?

    override func start() {
        guard let recipesModuleView = ModuleBuilder.makeRecipesModule(coordinator: self) as? RecipesViewController
        else { return }
        navigationController = UINavigationController(rootViewController: recipesModuleView)
    }

    func showCategory(category: RecipesCategory) {
        guard let categoryModule = ModuleBuilder.makeCategoryModule(
            coordinator: self,
            category: category
        ) as? CategoryViewController
        else { return }
        navigationController?.pushViewController(categoryModule, animated: true)
    }

    func closeCategory() {
        guard (navigationController?.viewControllers.last as? CategoryViewController) != nil else {
            return
        }
        navigationController?.popViewController(animated: true)
    }

    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
