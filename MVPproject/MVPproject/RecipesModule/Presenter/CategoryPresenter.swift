// CategoryPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол презентера экрана категории
protocol CategoryPresenterProtocol: AnyObject {
    /// Рецепты в категории
    var recipes: [Recipe] { get }
    /// Состояние загрузки
    var viewState: ViewState<[Recipe]> { get }
    /// Запрос на закрытие категории
    func closeCategory()
    /// Переход на экран с детальным описанием рецепта
    func showRecipeDetails(recipe: Recipe)
    /// Метод для получения состояниия кнопки калории
    func stateByCalories(state: SortingButton.SortState)
    /// Метод для получения состояния кнопки time
    func stateByTime(state: SortingButton.SortState)
    /// Обновление строки в поиске
    func updateSearchTerm(_ search: String)
    /// Экран загружен
    func screenLoaded()
    /// Перезагрузка данных из сети
    func reloadData()
    /// Загрузка изображений
    func loadImage(url: URL?, completion: @escaping (Data) -> ())
}

/// Презентер экрана категории
final class CategoryPresenter {
    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol?
    private weak var view: CategoryViewProtocol?
    private weak var coordinator: RecipesCoordinator?
    private var loadImageService: LoadImageServiceProtocol?
    private var uri: String?

    private var timeSortingState = SortingButton.SortState.unsorted {
        didSet {
            sortRecipes(by: timeSortingState, caloriesSortState: caloriesSortingState)
        }
    }

    private var caloriesSortingState = SortingButton.SortState.unsorted {
        didSet {
            sortRecipes(by: timeSortingState, caloriesSortState: caloriesSortingState)
        }
    }

    private(set) var viewState: ViewState<[Recipe]> = .loading {
        didSet {
            updateRecipesView()
        }
    }

    private var searchTerm: String = "" {
        didSet {
            if oldValue != searchTerm {
                searchRecipes(searchTerm)
            }
        }
    }

    private var category: RecipesCategory
    private(set) var recipes: [Recipe] = []

    // MARK: - initializators

    init(
        view: CategoryViewProtocol,
        coordinator: RecipesCoordinator,
        networkService: NetworkServiceProtocol?,
        category: RecipesCategory,
        loadImageService: LoadImageServiceProtocol?
    ) {
        self.view = view
        self.coordinator = coordinator
        self.category = category
        self.networkService = networkService
        self.loadImageService = loadImageService
        view.setScreenTitle(category.name)
        loadRecipes(byCategory: category)
    }

    private func loadRecipes(byCategory category: RecipesCategory) {
        viewState = .loading
        let storage = StorageService.shared.fetchRecipeData(category: category.type.rawValue)
        if storage.isEmpty {
            networkService?.getRecipesByCategory(CategoryRequestDTO(category: category)) { [weak self] result in
                switch result {
                case let .success(data):
                    StorageService.shared.createRecipeData(recipes: data, category: category)
                    self?.viewState = .data(data)
                case .failure(.emptyData):
                    self?.viewState = .noData
                case let .failure(error):
                    self?.viewState = .error(error)
                }
            }
        } else {
            viewState = .data(storage)
        }
    }

    private func searchRecipes(_ search: String) {
        viewState = .loading
        networkService?.getRecipesByCategory(CategoryRequestDTO(
            category: category,
            searchTerm: search
        )) { [weak self] result in
            switch result {
            case .failure(.emptyData):
                self?.viewState = .noData
            case let .failure(error):
                self?.viewState = .error(error)
            case let .success(data):
                self?.viewState = .data(data)
            }
        }
    }

    private func updateRecipesView() {
        switch viewState {
        case let .data(recipes):
            self.recipes = recipes
            view?.endRefresh()
        case .noData, .error:
            view?.endRefresh()
        default:
            break
        }
        view?.reloadRecipeTable()
    }

    private func sortRecipes(by timeSortState: SortingButton.SortState, caloriesSortState: SortingButton.SortState) {
        let sortedRecipes = recipes.sorted { recipe1, recipe2 in
            if timeSortState == .ascending, recipe1.cookingTime != recipe2.cookingTime {
                return recipe1.cookingTime > recipe2.cookingTime
            }
            if timeSortState == .descending, recipe1.cookingTime != recipe2.cookingTime {
                return recipe1.cookingTime < recipe2.cookingTime
            }
            if caloriesSortState == .ascending {
                return recipe1.calories > recipe2.calories
            }
            if caloriesSortState == .descending {
                return recipe1.calories < recipe2.calories
            }
            return true
        }
        viewState = .data(sortedRecipes)
    }
}

// MARK: - CategoryPresenter + CategoryPresenterProtocol

extension CategoryPresenter: CategoryPresenterProtocol {
    func loadImage(url: URL?, completion: @escaping (Data) -> ()) {
        loadImageService?.loadImage(url: url) { data, _, _ in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }

    func reloadData() {
        loadRecipes(byCategory: category)
    }

    func screenLoaded() {
        TxtFileLoggerInvoker.shared.log(.viewScreen(ScreenInfo(title: "Category")))
        TxtFileLoggerInvoker.shared.log(.openCategory(category))
    }

    func updateSearchTerm(_ search: String) {
        if search.count < 3 {
            searchTerm = ""
        } else {
            searchTerm = search
        }
    }

    func stateByTime(state: SortingButton.SortState) {
        timeSortingState = state
    }

    func stateByCalories(state: SortingButton.SortState) {
        caloriesSortingState = state
    }

    func closeCategory() {
        coordinator?.closeCategory()
    }

    func showRecipeDetails(recipe: Recipe) {
        coordinator?.showDetails(recipe: recipe)
    }
}
