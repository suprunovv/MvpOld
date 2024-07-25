// NutrientsDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Структура КБЖУ
struct NutrientsDTO: Codable {
    /// Белки
    let proteins: QuantityDTO
    /// Жиры
    let fats: QuantityDTO
    /// Углеводы
    let carbohydrates: QuantityDTO
    /// Калории
    let calories: QuantityDTO

    enum CodingKeys: String, CodingKey {
        case proteins = "PROCNT"
        case fats = "FAT"
        case carbohydrates = "CHOCDF"
        case calories = "ENERC_KCAL"
    }
}
