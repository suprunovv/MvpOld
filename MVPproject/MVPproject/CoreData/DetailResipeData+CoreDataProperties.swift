// DetailResipeData+CoreDataProperties.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

/// Расширение с описанием для модели деталей
public extension DetailRecipeData {
    @nonobjc class func fetchRequest() -> NSFetchRequest<DetailRecipeData> {
        NSFetchRequest<DetailRecipeData>(entityName: "DetailRecipeData")
    }

    @NSManaged var uri: String
    @NSManaged var weight: Int16
    @NSManaged var ingredientLines: String?
    @NSManaged var fats: Int16
    @NSManaged var proteins: Int16
    @NSManaged var carbohydrates: Int16
    @NSManaged var calories: Int16
}
