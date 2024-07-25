// RecipesCategoriesDataSource.swift
// Copyright © RoadMap. All rights reserved.

/// Моковые данные для категорий рецептов
struct RecipesCategoriesDataSource {
    static let categories: [RecipesCategory] = [
        RecipesCategory(type: .salad, name: "Salad", imageName: "salad"),
        RecipesCategory(type: .soup, name: "Soup", imageName: "soup"),
        RecipesCategory(type: .chicken, name: "Chicken", imageName: "chicken"),
        RecipesCategory(type: .meat, name: "Meat", imageName: "meat"),
        RecipesCategory(type: .fish, name: "Fish", imageName: "fish"),
        RecipesCategory(type: .sideDish, name: "Side dish", imageName: "sideDish"),
        RecipesCategory(type: .drinks, name: "Drinks", imageName: "drinks"),
        RecipesCategory(type: .pancake, name: "Pancake", imageName: "pancakes"),
        RecipesCategory(type: .dessert, name: "Desserts", imageName: "desserts")
    ]
}
