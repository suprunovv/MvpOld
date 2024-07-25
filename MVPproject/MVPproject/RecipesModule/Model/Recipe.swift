// Recipe.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Детали рецепта
struct RecipeDetails: Codable {
    /// Вес готового блюда
    let weight: Int
    /// Ингридиенты
    let ingredientLines: String
    /// Белки
    let proteins: Int
    /// Жиры
    let fats: Int
    /// Углеводы
    let carbohydrates: Int
    /// Калории
    let calories: Int

    init(weight: Int, ingredientLines: String, proteins: Int, fats: Int, carbohydrates: Int, calories: Int) {
        self.weight = weight
        self.ingredientLines = ingredientLines
        self.proteins = proteins
        self.fats = fats
        self.carbohydrates = carbohydrates
        self.calories = calories
    }

    init(detailRecipeData: DetailRecipeData) {
        weight = Int(detailRecipeData.weight)
        ingredientLines = detailRecipeData.ingredientLines ?? ""
        proteins = Int(detailRecipeData.proteins)
        fats = Int(detailRecipeData.fats)
        carbohydrates = Int(detailRecipeData.carbohydrates)
        calories = Int(detailRecipeData.calories)
    }
}

/// Модель рецепта
struct Recipe: Codable {
    /// Имя картинки
    let imageURL: URL?
    /// Название рецепта
    let name: String
    /// Время приготовления
    let cookingTime: Int
    /// Количество калорий
    let calories: Int
    /// Детали рецепта
    var details: RecipeDetails?
    /// uri
    let uri: String?

    init(
        imageURL: URL?,
        name: String,
        cookingTime: Int,
        calories: Int,
        details: RecipeDetails? = nil,
        uri: String
    ) {
        self.imageURL = imageURL
        self.name = name
        self.calories = calories
        self.cookingTime = cookingTime
        self.details = details
        self.uri = uri
    }

    init(recipeData: RecipeData) {
        imageURL = URL(string: recipeData.imageURL ?? "")
        name = recipeData.name ?? ""
        cookingTime = Int(recipeData.cookingTime)
        calories = Int(recipeData.calories)
        uri = recipeData.uri
        details = nil
    }

    init?(dto: RecipeDTO) {
        name = dto.label
        calories = Int(dto.calories.rounded())
        cookingTime = Int(dto.totalTime.rounded())
        imageURL = URL(string: dto.image)
        details = nil
        uri = dto.uri
    }

    init?(dto: RecipeDetailsDTO) {
        name = dto.label
        calories = Int(dto.totalNutrients.calories.quantity.rounded())
        cookingTime = Int(dto.totalTime.rounded())
        imageURL = URL(string: dto.image)
        details = RecipeDetails(
            weight: Int(dto.totalWeight.rounded()),
            ingredientLines: dto.ingredientLines.joined(separator: "\n"),
            proteins: Int(dto.totalNutrients.proteins.quantity.rounded()),
            fats: Int(dto.totalNutrients.fats.quantity.rounded()),
            carbohydrates: Int(dto.totalNutrients.carbohydrates.quantity.rounded()),
            calories: Int(dto.totalNutrients.calories.quantity.rounded())
        )
        uri = nil
    }
}
