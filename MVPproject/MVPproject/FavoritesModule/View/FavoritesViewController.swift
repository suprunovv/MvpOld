// FavoritesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол представления Избранное
protocol FavoritesViewProtocol: AnyObject {
    /// Показать сообщение пустой страницы
    func showEmptyMessage()
    /// Показать избранные рецепты
    func showFavorites()
    /// Обновить таблицу с рецептами
    func reloadRecipesTable()
}

/// Избранное
final class FavoritesViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let title = "Favorites"
        static let emptyPageTitle = "There's nothing here yet"
        static let emptyPageDescription = "Add interesting recipes to make ordering products convenient"
        static let emptyMessageToViewSpacing = 20.0
    }

    // MARK: - Visual Components

    private let emptyMessageView = MessageView(config: MessageViewConfig(
        icon: .bookmarkSquare,
        title: Constants.emptyPageTitle,
        description: Constants.emptyPageDescription
    ))

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.reuseID)
        tableView.separatorStyle = .none
        tableView.isHidden = true
        tableView.disableAutoresizingMask()
        return tableView
    }()

    // MARK: - Public Properties

    var presenter: FavoritesPresenterProtocol?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.screenLoaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        presenter?.refreshFavorites()
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = .white
        view.addSubviews(tableView, emptyMessageView)
        setupTableConstraints()
        setupEmptyMessageConstraints()
        setupNavigationItem()

        presenter?.refreshFavorites()
    }

    private func setupNavigationItem() {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 28)
        label.textColor = .black
        label.text = Constants.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }

    private func setupTableConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupEmptyMessageConstraints() {
        NSLayoutConstraint.activate([
            emptyMessageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyMessageView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.emptyMessageToViewSpacing
            ),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(
                equalTo: emptyMessageView.trailingAnchor,
                constant: Constants.emptyMessageToViewSpacing
            )
        ])
    }
}

// MARK: - FavoritesViewController + UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FavoriteRecipes.shared.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = FavoriteRecipes.shared.recipes[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.reuseID) as? RecipeCell
        else { return .init() }
        cell.configure(withRecipe: recipe)
        return cell
    }
}

// MARK: - FavoritesViewController + UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = FavoriteRecipes.shared.recipes[indexPath.row]
        presenter?.showRecipeDetails(recipe: recipe)
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        let recipe = FavoriteRecipes.shared.recipes[indexPath.row]
        if editingStyle == .delete {
            FavoriteRecipes.shared.updateFavoriteRecipe(recipe)
            tableView.deleteRows(at: [indexPath], with: .fade)
            FavoriteRecipes.shared.encodeRecipes()
            presenter?.refreshFavorites()
        }
    }
}

// MARK: - FavoritesViewController + FavoritesViewProtocol

extension FavoritesViewController: FavoritesViewProtocol {
    func reloadRecipesTable() {
        tableView.reloadData()
    }

    func showEmptyMessage() {
        emptyMessageView.isHidden = false
        tableView.isHidden = true
    }

    func showFavorites() {
        emptyMessageView.isHidden = true
        tableView.isHidden = false
    }
}
