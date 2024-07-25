// RecipesCategoryCellConfig.swift
// Copyright © RoadMap. All rights reserved.

/// Модель данных в ячейке категории
struct RecipesCategoryCellConfig {
    /// Перечисление размеров ячейки
    enum RecipesCategoryCellSize {
        /// Маленькая
        case small
        /// Средняя
        case middle
        /// Большая
        case big
    }

    /// Категория рецепта
    let recipeCategory: RecipesCategory
    /// Тип ячейки
    let cellSize: RecipesCategoryCellSize
}

/// Структура с методом возвращающим массив типов рецепта
struct RecipesCategoriesCollectionConfig {
    typealias CellSize = RecipesCategoryCellConfig.RecipesCategoryCellSize

    static let cellsLayoutConfiguration: [CellSize] = [.middle, .middle, .big, .small, .small, .small, .big]

    static func getRecipesCategoryCellConfigs() -> [RecipesCategoryCellConfig] {
        var cellConfigs: [RecipesCategoryCellConfig] = []
        for (index, category) in RecipesCategoriesDataSource.categories.enumerated() {
            let cellLayoutIndex = index % cellsLayoutConfiguration.count
            let cellSize = cellsLayoutConfiguration[cellLayoutIndex]
            cellConfigs.append(
                RecipesCategoryCellConfig(
                    recipeCategory: category,
                    cellSize: cellSize
                )
            )
        }
        return cellConfigs
    }
}
