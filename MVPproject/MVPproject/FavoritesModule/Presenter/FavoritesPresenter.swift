// FavoritesPresenter.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокл презентера избранных рецептов
protocol FavoritesPresenterProtocol: AnyObject {
    /// Запрос на открытие деталей о рецепте
    func showRecipeDetails(recipe: Recipe)
    /// Обновить избранное
    func refreshFavorites()
    /// Экран загружен
    func screenLoaded()
}

/// Презентер избранных рецептов
final class FavoritesPresenter {
    private weak var view: FavoritesViewProtocol?
    private weak var coordinator: FavoritesCoordinator?

    init(view: FavoritesViewProtocol, coordinator: FavoritesCoordinator) {
        self.view = view
        self.coordinator = coordinator
    }
}

// MARK: - FavoritesPresenter + FavoritesPresenterProtocol

extension FavoritesPresenter: FavoritesPresenterProtocol {
    func screenLoaded() {
        TxtFileLoggerInvoker.shared.log(.viewScreen(ScreenInfo(title: "Favorites")))
    }

    func refreshFavorites() {
        if FavoriteRecipes.shared.recipes.isEmpty {
            view?.showEmptyMessage()
        } else {
            view?.showFavorites()
        }
    }

    func showRecipeDetails(recipe: Recipe) {
        coordinator?.showDetails(recipe: recipe)
    }
}
