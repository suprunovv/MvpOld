// RecipeData+CoreDataProperties.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

/// Расширение модели рецепта с описанием для хранения
public extension RecipeData {
    @nonobjc class func fetchRequest() -> NSFetchRequest<RecipeData> {
        NSFetchRequest<RecipeData>(entityName: "RecipeData")
    }

    @NSManaged var category: String
    @NSManaged var imageURL: String?
    @NSManaged var name: String?
    @NSManaged var cookingTime: Int16
    @NSManaged var calories: Int16
    @NSManaged var details: NSObject?
    @NSManaged var uri: String?
}
