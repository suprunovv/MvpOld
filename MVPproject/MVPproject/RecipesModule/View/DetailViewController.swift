// DetailViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол для вью детального экрана
protocol DetailViewProtocol: AnyObject {
    /// Перезагрузка таблицы
    func reloadData()
    /// Завершить pull to refresh
    func endRefresh()
}

/// Вью экрана с детальным описанием рецепта
final class DetailViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let noDataMessageConfig = MessageViewConfig(
            icon: .searchSquare,
            title: SwiftGenStrings.DetailViewController.emptyDataTitle,
            description: SwiftGenStrings.DetailViewController.emptyDataDescription,
            withReload: true
        )
        static let errorMessageConfig = MessageViewConfig(
            icon: .boltSquare,
            title: nil,
            description: SwiftGenStrings.DetailViewController.errorMessageDescription,
            withReload: true
        )
    }

    // MARK: - Visual components

    private let detailsTableView = UITableView()

    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.paperplane, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.bookmarkBarIcon, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(addFavorites), for: .touchUpInside)
        return button
    }()

    private let messageView = MessageView()

    private lazy var backButton = UIBarButtonItem(
        image: .arrowBack,
        style: .plain,
        target: self,
        action: #selector(closeDetail)
    )

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()

    // MARK: - Public properties

    var presenter: DetailPresenterProtocol?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.screenLoaded()
    }

    // MARK: - Private methods

    private func setupView() {
        view.backgroundColor = .white
        setTableViewConstraints()
        setupDetailsTableView()
        setNavigationBar()
        detailsTableView.refreshControl = refreshControl
    }

    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = backButton
        let shareItem = UIBarButtonItem(customView: shareButton)
        let favoriteItem = UIBarButtonItem(customView: favoriteButton)
        navigationItem.rightBarButtonItems = [favoriteItem, shareItem]
    }

    private func setTableViewConstraints() {
        view.addSubview(detailsTableView)
        detailsTableView.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            detailsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupDetailsTableView() {
        detailsTableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.reuseID)
        detailsTableView.register(
            EnergyValueTableViewCell.self,
            forCellReuseIdentifier: EnergyValueTableViewCell.reuseID
        )
        detailsTableView.register(FullRecipeTableViewCell.self, forCellReuseIdentifier: FullRecipeTableViewCell.reuseID)
        detailsTableView.register(
            DetailsShimmerTableViewCell.self,
            forCellReuseIdentifier: DetailsShimmerTableViewCell.reuseID
        )
        detailsTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.reuseID)
        detailsTableView.rowHeight = UITableView.automaticDimension
        detailsTableView.allowsSelection = false
        detailsTableView.separatorStyle = .none
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
    }

    @objc private func closeDetail() {
        presenter?.closeDetails()
    }

    @objc private func addFavorites() {
        presenter?.addFavoriteRecipe()
        FavoriteRecipes.shared.encodeRecipes()
    }

    @objc private func shareButtonTapped() {
        presenter?.shareRecipe()
    }

    @objc private func refreshData() {
        presenter?.reloadData()
    }
}

// MARK: - DetailViewController + DetailViewProtocol

extension DetailViewController: DetailViewProtocol {
    func endRefresh() {
        refreshControl.endRefreshing()
    }

    func reloadData() {
        detailsTableView.reloadData()
    }
}

// MARK: - DetailViewController + UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch presenter?.viewState {
        case .loading, .noData, .error:
            return 1
        case .data:
            return presenter?.cellTypes.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter?.viewState {
        case .loading:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: DetailsShimmerTableViewCell
                        .reuseID
                ) as? DetailsShimmerTableViewCell else { return .init() }
            return cell
        case let .data(recipe):
            return dequeDataCell(tableView, indexPath: indexPath, recipe: recipe)
        case .noData:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseID) as? MessageTableViewCell
            else { return .init() }
            cell.configureCell(messageViewConfig: Constants.noDataMessageConfig)
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

    private func dequeDataCell(_ tableView: UITableView, indexPath: IndexPath, recipe: Recipe) -> UITableViewCell {
        let cells = presenter?.cellTypes
        guard let cells = cells else { return .init() }
        switch cells[indexPath.row] {
        case .image:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ImageTableViewCell.reuseID,
                for: indexPath
            ) as? ImageTableViewCell else { return .init() }
            presenter?.loadImage(url: recipe.imageURL, completion: { data in
                cell.setImage(data)
            })
            cell.configureCell(recipe: recipe)
            return cell
        case .energy:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: EnergyValueTableViewCell.reuseID,
                for: indexPath
            ) as? EnergyValueTableViewCell else { return .init() }
            cell.setupCell(recipe: recipe)
            return cell
        case .description:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FullRecipeTableViewCell.reuseID,
                for: indexPath
            ) as? FullRecipeTableViewCell else { return UITableViewCell() }
            cell.setupDescription(text: recipe.details?.ingredientLines)
            return cell
        }
    }
}

// MARK: - DetailViewController + UITableViewDelegate

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch presenter?.viewState {
        case .loading, .noData, .error:
            return tableView.bounds.height
        case .data:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
}

// MARK: - DetailViewController + MessageViewDelegate

extension DetailViewController: MessageViewDelegate {
    func reload() {
        presenter?.reloadData()
    }
}
