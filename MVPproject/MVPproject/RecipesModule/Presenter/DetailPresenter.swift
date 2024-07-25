// DetailPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол для презентера детального экрана
protocol DetailPresenterProtocol: AnyObject {
    /// Mассив типов ячеек
    var cellTypes: [DetailCellType] { get }
    /// Рецепт
    var recipe: Recipe? { get set }
    /// Метод закрывает экран деталей
    func closeDetails()
    /// Экран загружен
    func screenLoaded()
    /// Пошарить рецепт
    func shareRecipe()
    /// Добавить рецепт в избранное
    func addFavoriteRecipe()
    /// Вью стейт
    var viewState: ViewState<Recipe> { get }
    /// Перезагрузка данных из сети
    func reloadData()
    /// Получение изобраения
    func loadImage(url: URL?, completion: @escaping (Data) -> ())
}

/// Перечисление возможных типов ячеек
enum DetailCellType {
    /// Ячейка с картинкой
    case image
    /// Ячейка с описанием энергетической ценности
    case energy
    /// Ячейка с описаниеп приготовления
    case description
}

/// Презентер детального экрана рецепта
final class DetailPresenter {
    // MARK: - Private properties

    var recipe: Recipe?
    private(set) var cellTypes: [DetailCellType] = [.image, .energy, .description]
    private let networkService: NetworkServiceProtocol?
    private(set) var viewState: ViewState<Recipe> = .loading {
        didSet {
            updateDetailView()
        }
    }

    private weak var view: DetailViewProtocol?
    private weak var coordinator: RecipeWithDetailsCoordinatorProtocol?
    private var uri: String?
    private var loadImageService: LoadImageServiceProtocol?

    // MARK: - Initializators

    init(
        view: DetailViewProtocol,
        coordinator: RecipeWithDetailsCoordinatorProtocol,
        networkService: NetworkServiceProtocol?,
        recipe: Recipe,
        loadImageService: LoadImageServiceProtocol?
    ) {
        self.view = view
        self.coordinator = coordinator
        uri = recipe.uri
        self.recipe = recipe
        self.networkService = networkService
        self.loadImageService = loadImageService
    }

    // MARK: - Private methods

    private func getDetails() {
        guard let uri = uri, !uri.isEmpty else { return }
        viewState = .loading
        let details = StorageService.shared.fetchDetailRecipe(uri: uri)
        if let details = details {
            guard var recipe = recipe else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                recipe.details = details
                self?.viewState = .data(recipe)
            }
        } else {
            networkService?.getRecipesDetailsByURI(uri, completion: { [weak self] result in
                switch result {
                case let .success(data):
                    guard let details = data.details else { return }
                    StorageService.shared.createRecipesDetailData(recipeDetails: details, uri: uri)
                    self?.viewState = .data(data)
                case .failure(.emptyData):
                    self?.viewState = .noData
                case let .failure(error):
                    self?.viewState = .error(error)
                }
            })
        }
    }

    private func updateDetailView() {
        switch viewState {
        case let .data(recipe):
            self.recipe = recipe
            view?.endRefresh()
        case .error, .noData:
            view?.endRefresh()
        default:
            break
        }
        view?.reloadData()
    }
}

// MARK: - DetailPresenter + DetailPresenterProtocol

extension DetailPresenter: DetailPresenterProtocol {
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
        getDetails()
    }

    func addFavoriteRecipe() {
        guard let recipe = recipe else { return }
        FavoriteRecipes.shared.updateFavoriteRecipe(recipe)
    }

    func shareRecipe() {
        guard let recipe = recipe else { return }
        TxtFileLoggerInvoker.shared.log(.shareRecipe(recipe))
    }

    func screenLoaded() {
        getDetails()
        guard let recipe = recipe else { return }
        TxtFileLoggerInvoker.shared.log(.viewScreen(ScreenInfo(title: "Recipe details")))
        TxtFileLoggerInvoker.shared.log(.openDetails(recipe))
    }

    func closeDetails() {
        coordinator?.closeDetails()
    }
}
