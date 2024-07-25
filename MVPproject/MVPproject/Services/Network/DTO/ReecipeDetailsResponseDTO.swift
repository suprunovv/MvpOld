// ReecipeDetailsResponseDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Детали рецепта
struct ReecipeDetailsResponseDTO: Codable {
    /// Хиты
    let hits: [DetailHitsDTO]
}
