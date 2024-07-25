// LogCommand.swift

import Foundation

/// Модель оиписывающая экран
struct ScreenInfo: Codable {
    let title: String
}

/// Комманда для логирования
enum LogCommand<OutputLog> {
    /// Открыт экран
    case viewScreen(ScreenInfo)
    /// Открыта категория
    case openCategory(RecipesCategory)
    /// Открыты дтали рецепта
    case openDetails(Recipe)
    /// Расшарен рецепт
    case shareRecipe(Recipe)
}

/// Расширение для лога типа строка
extension LogCommand where OutputLog == String {
    var log: String {
        switch self {
        case let .shareRecipe(recipe):
            return "Shared recipe: \(recipe.name)"
        case let .openDetails(recipe):
            return "View recipe details: \(recipe.name)"
        case let .viewScreen(screen):
            return "Viewed screen: \(screen.title)"
        case let .openCategory(category):
            return "Viewed category: \(category.name)"
        }
    }
}

///// Расширение для лога типа дата
// extension LogCommand where OutputLog == Data {
//    var log: Data? {
//        switch self {
//        case let .shareRecipe(data as Codable), let .viewScreen(data as Codable),
//             let .openCategory(data as Codable), let .openDetails(data as Codable):
//            return try? JSONEncoder().encode(data)
//        }
//    }
// }
