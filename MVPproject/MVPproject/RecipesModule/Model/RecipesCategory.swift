// RecipesCategory.swift
// Copyright © RoadMap. All rights reserved.

/// Модель категории рецептов
struct RecipesCategory: Codable {
    /// Виды категорий
    enum CategoryType: String, Codable {
        /// Салат
        case salad
        /// Суп
        case soup
        /// Курица
        case chicken
        /// Мясо
        case meat
        /// Рыба
        case fish
        /// Гарнир
        case sideDish
        /// Напитки
        case drinks
        /// Блины
        case pancake
        /// Десерты
        case dessert
    }

    /// Идентификатор категории
    let type: CategoryType
    /// Название категории рецепта
    let name: String
    /// Название пикчи категории рецепта
    let imageName: String
}
