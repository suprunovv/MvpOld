// DetailHitsDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Блюдо-хит с деталями
struct DetailHitsDTO: Codable {
    /// Рецепт
    let recipe: RecipeDetailsDTO
}
