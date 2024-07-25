// CategoryViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол представления категории рецептов
protocol CategoryViewProtocol: AnyObject {
    /// Метод установки заголовка экрана
    func setScreenTitle(_ title: String)
    /// Метод обновляющий таблицу с рецептами
    func reloadRecipeTable()
    /// завершение pull to refresh
    func endRefresh()
}

/// Вью экрана выбранной категории рецепта
final class CategoryViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let searchBarToTableSpacing = 12.0
        static let sortingHeight = 36.0
        static let sortingToViewSpacing = 20.0
        static let searchBarInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        static let sortingHeaderHeight = 20.0
        static let emptyMessageToViewSpacing = 20.0
        static let mockRecipesCount = 7
        static let noDataMessageConfig = MessageViewConfig(
            icon: .searchSquare,
            title: nil,
            description: SwiftGenStrings.Category.emptyPageDescription
        )
        static let notFoundMessageConfig = MessageViewConfig(
            icon: .searchSquare,
            title: SwiftGenStrings.Category.notFoundTitle,
            description: SwiftGenStrings.Category.notFoundDescription
        )
        static let errorMessageConfig = MessageViewConfig(
            icon: .boltSquare,
            title: nil,
            description: SwiftGenStrings.Category.errorMessageDescription,
            withReload: true
        )
    }

    // MARK: - Visual Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 28)
        label.textColor = .black
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.accessibilityIdentifier = "tableView"
        tableView.delegate = self
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.reuseID)
        tableView.register(RecipeShimmeredCell.self, forCellReuseIdentifier: RecipeShimmeredCell.reuseID)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.reuseID)
        tableView.separatorStyle = .none
        tableView.disableAutoresizingMask()
        return tableView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: SwiftGenStrings.Category.searchBarPlaceholder,
            attributes: [
                .font: UIFont.verdana(ofSize: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.grayTextPlaceholder
            ]
        )
        searchBar.searchBarStyle = .minimal
        searchBar.layoutMargins = Constants.searchBarInsets
        searchBar.disableAutoresizingMask()
        return searchBar
    }()

    private lazy var sortButtonsView = SortButtonsView()

    private lazy var backButton = UIBarButtonItem(
        image: .arrowBack,
        style: .plain,
        target: self,
        action: #selector(closeCategory)
    )

    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return refresh
    }()

    // MARK: - Public properties

    var presenter: CategoryPresenterProtocol?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.screenLoaded()
    }

    // MARK: - Private methods

    private func setupView() {
        view.backgroundColor = .white
        view.addSubviews(tableView, searchBar, sortButtonsView)
        sortButtonsView.delegate = self
        setupConstraints()
        tableView.refreshControl = refreshControl
    }

    private func setupConstraints() {
        tableView.setContentHuggingPriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            sortButtonsView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: Constants.searchBarToTableSpacing
            ),
            sortButtonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sortButtonsView.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(
                equalTo: sortButtonsView.bottomAnchor,
                constant: Constants.searchBarToTableSpacing
            ),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func closeCategory() {
        presenter?.closeCategory()
    }

    @objc private func refreshData(_ sender: UIRefreshControl) {
        presenter?.reloadData()
    }
}

// MARK: - CategoryViewController + CategoryViewProtocol

extension CategoryViewController: CategoryViewProtocol {
    func endRefresh() {
        refreshControl.endRefreshing()
    }

    func reloadRecipeTable() {
        tableView.reloadData()
    }

    func setScreenTitle(_ title: String) {
        titleLabel.text = title
        let titleBarItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.setLeftBarButtonItems([backButton, titleBarItem], animated: false)
    }
}

// MARK: - CategoryViewController + UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch presenter?.viewState {
        case .loading:
            return Constants.mockRecipesCount
        case let .data(recipes):
            return recipes.count
        case .noData, .error:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter?.viewState {
        case .loading:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: RecipeShimmeredCell.reuseID) as? RecipeShimmeredCell
            else { return .init() }
            tableView.isScrollEnabled = false
            tableView.allowsSelection = false
            return cell
        case let .data(recipes):
            let recipe = recipes[indexPath.row]
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: RecipeCell.reuseID) as? RecipeCell
            else { return .init() }
            tableView.isScrollEnabled = true
            tableView.allowsSelection = true
            presenter?.loadImage(url: recipe.imageURL, completion: { imageData in
                cell.setImage(imageData)
            })
            cell.configure(withRecipe: recipe)
            return cell
        case .noData:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseID) as? MessageTableViewCell
            else { return .init() }
            if let search = searchBar.text, !search.isEmpty {
                cell.configureCell(messageViewConfig: Constants.notFoundMessageConfig)
            } else {
                cell.configureCell(messageViewConfig: Constants.noDataMessageConfig)
            }
            cell.delegate = self
            return cell
        case .error:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseID) as? MessageTableViewCell
            else { return .init() }
            cell.configureCell(messageViewConfig: Constants.errorMessageConfig)
            cell.delegate = self
            return cell
        default:
            return .init()
        }
    }
}

// MARK: - CategoryViewController + UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch presenter?.viewState {
        case .noData, .error:
            return tableView.bounds.height
        case .loading, .data:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipe = presenter?.recipes[indexPath.row] else { return }
        presenter?.showRecipeDetails(recipe: recipe)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - CategoryViewController + SortButtonViewDelegate

extension CategoryViewController: SortButtonViewDelegate {
    func updateTimeSorting(_ sorting: SortingButton.SortState) {
        presenter?.stateByTime(state: sorting)
    }

    func updateCaloriesSorting(_ sorting: SortingButton.SortState) {
        presenter?.stateByCalories(state: sorting)
    }
}

// MARK: - CategoryViewController + UISearchBarDelegate

extension CategoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.updateSearchTerm(searchText)
    }
}

// MARK: - CategoryViewController + MessageViewDelegate

extension CategoryViewController: MessageViewDelegate {
    func reload() {
        presenter?.reloadData()
    }
}
