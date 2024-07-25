// RecipesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol RecipesViewProtocol: AnyObject {
    func updateRecipes(categories: [RecipesCategoryCellConfig])
    /// Метод обновляет данные в коллекции
    func reloadCollection()
}

/// Вью экрана с типами рецептов
final class RecipesViewController: UIViewController {
    // MARK: - Constants

    enum Constants {
        static let minimumLineSpacing: CGFloat = 15
        static let minimumInteritemSpacing: CGFloat = 10
    }

    // MARK: - Public properties

    var presenter: RecipesPresenterProtocol?

    // MARK: - Private properties

    private var typeDishCollectionView: UICollectionView?

    // MARK: - Moke Data

    private var recipesCategories: [RecipesCategoryCellConfig] = []

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        presenter?.screenLoaded()
    }

    // MARK: - Private methods

    private func setViews() {
        view.backgroundColor = .white
        setupDishCollection()
        setTitle()
        presenter?.getRecipesCategory()
    }

    private func setTitle() {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 28)
        label.textColor = .black
        label.text = SwiftGenStrings.RecipesScreen.titleText

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }

    private func makeFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        return layout
    }

    private func setupDishCollection() {
        typeDishCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeFlowLayout()
        )
        guard let typeDishCollectionView else { return }
        typeDishCollectionView.register(
            RecipesCategoryCell.self,
            forCellWithReuseIdentifier: RecipesCategoryCell.reuseID
        )
        typeDishCollectionView.register(ShimmerCell.self, forCellWithReuseIdentifier: ShimmerCell.reuseID)
        typeDishCollectionView.delegate = self
        typeDishCollectionView.dataSource = self
        view.addSubview(typeDishCollectionView)
        typeDishCollectionView.disableAutoresizingMask()
        NSLayoutConstraint.activate([
            typeDishCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            typeDishCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            typeDishCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            typeDishCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - RecipesViewController + UICollectionViewDataSource

extension RecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipesCategories.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let isLoading = presenter?.isLoadingData ?? .isLoading
        switch isLoading {
        case .isLoaded:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecipesCategoryCell.reuseID,
                for: indexPath
            ) as? RecipesCategoryCell else { return UICollectionViewCell() }
            cell.setupCell(category: recipesCategories[indexPath.item])
            return cell
        case .isLoading:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ShimmerCell.reuseID,
                for: indexPath
            ) as? ShimmerCell else { return UICollectionViewCell() }
            return cell
        }
    }
}

// MARK: - RecipesViewController + UICollectionViewDelegate

extension RecipesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.showRecipesByCategory(category: recipesCategories[indexPath.item])
    }
}

// MARK: - RecipesViewController + UICollectionViewDelegateFlowLayout

extension RecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch recipesCategories[indexPath.item].cellSize {
        case .middle:
            return CGSize(
                width: view.bounds.width / 2 - 22,
                height: view.bounds.width / 2 - 22
            )
        case .big:
            return CGSize(
                width: view.bounds.width - 140,
                height: view.bounds.width - 140
            )
        case .small:
            return CGSize(
                width: view.bounds.width / 3 - 18,
                height: view.bounds.width / 3 - 18
            )
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - RecipesViewController + RecipesViewProtocol

extension RecipesViewController: RecipesViewProtocol {
    func reloadCollection() {
        typeDishCollectionView?.reloadData()
    }

    func updateRecipes(categories: [RecipesCategoryCellConfig]) {
        recipesCategories = categories
    }
}
