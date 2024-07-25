// RecipesResponseDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Рецепты с хитами
struct RecipesResponseDTO: Codable {
    /// Рецепты
    let hits: [HitDTO]
}
