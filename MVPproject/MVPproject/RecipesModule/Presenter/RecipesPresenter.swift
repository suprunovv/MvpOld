// RecipesPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Перечисление с состояниями загрузки данных
enum LoadingState {
    /// Данные загружены
    case isLoaded
    /// Данные еще не загружены
    case isLoading
}

/// Протокол для презентера экрана рецептов
protocol RecipesPresenterProtocol: AnyObject {
    /// Метод показывает выбранную категорию рецепта
    func showRecipesByCategory(category: RecipesCategoryCellConfig)
    /// Метод посылает на вью данные о категориях
    func getRecipesCategory()
    /// Свойство отображающее загружены ли данные
    var isLoadingData: LoadingState { get }
    /// Экран загружен
    func screenLoaded()
}

/// Презентер для экрана с типами рецептов

final class RecipesPresenter {
    // MARK: - Private properties

    private var timer = Timer()
    private weak var view: RecipesViewProtocol?
    private weak var recipesCoordinator: RecipesCoordinator?
    private(set) var isLoadingData: LoadingState = .isLoading

    // MARK: - Initializers

    init(view: RecipesViewProtocol, coordinator: RecipesCoordinator) {
        self.view = view
        recipesCoordinator = coordinator
        startLoadingData()
    }

    // MARK: - Private methods

    private func startLoadingData() {
        timer = Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(updateLoadingDate),
            userInfo: nil,
            repeats: false
        )
    }

    @objc private func updateLoadingDate() {
        isLoadingData = .isLoaded
        view?.reloadCollection()
        timer.invalidate()
    }
}

// MARK: - RecipesPresenter + RecipesPresenterProtocol

extension RecipesPresenter: RecipesPresenterProtocol {
    func screenLoaded() {
        TxtFileLoggerInvoker.shared.log(.viewScreen(ScreenInfo(title: "Recipes")))
    }

    func getRecipesCategory() {
        let categories = RecipesCategoriesCollectionConfig.getRecipesCategoryCellConfigs()
        view?.updateRecipes(categories: categories)
    }

    func showRecipesByCategory(category: RecipesCategoryCellConfig) {
        recipesCoordinator?.showCategory(category: category.recipeCategory)
    }
}
