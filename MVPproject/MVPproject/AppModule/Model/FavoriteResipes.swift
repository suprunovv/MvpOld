// FavoriteResipes.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель с массивом любимых рецептов
final class FavoriteRecipes {
    // MARK: - Constants

    private enum Constants {
        static let recipeKey = "recipeKey"
    }

    static let shared = FavoriteRecipes()

    // MARK: - Private properties

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private(set) var recipes: [Recipe] = []

    // MARK: - Initializaters

    private init() {}

    // MARK: - Public methods

    func updateFavoriteRecipe(_ recipe: Recipe) {
        if recipes.isEmpty {
            recipes.append(recipe)
        } else {
            for (index, value) in recipes.enumerated() where recipe.name == value.name {
                self.recipes.remove(at: index)
                return
            }
            recipes.append(recipe)
        }
    }

    func encodeRecipes() {
        if let encodeResipes = try? encoder.encode(recipes) {
            UserDefaults.standard.set(encodeResipes, forKey: Constants.recipeKey)
        }
    }

    func getRecipes() {
        if let savedResipesData = UserDefaults.standard.object(forKey: Constants.recipeKey) as? Data {
            if let savedRecipes = try? decoder.decode([Recipe].self, from: savedResipesData) {
                recipes = savedRecipes
            }
        }
    }
}
