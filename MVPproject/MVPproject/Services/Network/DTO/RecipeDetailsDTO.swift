// RecipeDetailsDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Детальное описание рецепта
struct RecipeDetailsDTO: Codable {
    /// Название редепта
    let label: String
    /// Картинка
    let image: String
    /// Вес блюда
    let totalWeight: Double
    /// Время приготовления
    let totalTime: Double
    /// Ингридиенты
    let ingredientLines: [String]
    /// Структура КБЖУ
    let totalNutrients: NutrientsDTO
}
