// UIColor+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Расширение для быстрого доступа к цветам
extension UIColor {
    static let grayLogo = UIColor(red: 77 / 255.0, green: 77 / 255.0, blue: 77 / 255.0, alpha: 1)
    static let grayText = UIColor(red: 71 / 255.0, green: 92 / 255.0, blue: 102 / 255.0, alpha: 1)
    static let grayTextSecondary = UIColor(red: 151 / 255.0, green: 162 / 255.0, blue: 176 / 255.0, alpha: 1)
    static let grayTextPlaceholder = UIColor(red: 208 / 255.0, green: 212 / 255.0, blue: 218 / 255.0, alpha: 1)
    static let greenAccent = UIColor(red: 112 / 255.0, green: 185 / 255.0, blue: 190 / 255.0, alpha: 1)
    static let greenBgAccent = UIColor(red: 241 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)
    static let greenDarkButton = UIColor(red: 4 / 255.0, green: 38 / 255.0, blue: 40 / 255.0, alpha: 1)
    static let redError = UIColor(red: 240 / 255.0, green: 97 / 255.0, blue: 85 / 255.0, alpha: 1)
    static let blueLight = UIColor(red: 242 / 255.0, green: 245 / 255.0, blue: 250 / 255.0, alpha: 1)
    static let greenAlpha = UIColor(red: 112 / 255.0, green: 185 / 255.0, blue: 190 / 255.0, alpha: 0.6)
    static let blueRecipeBg = UIColor(red: 222 / 255.0, green: 238 / 255.0, blue: 239 / 255.0, alpha: 1)
    static let grayShimmer = UIColor(red: 225 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1)
    static let grayHandle = UIColor(red: 242 / 255.0, green: 242 / 255.0, blue: 242 / 255.0, alpha: 1)
    static let nameLabel = UIColor(red: 71 / 255, green: 92 / 255, blue: 102 / 255, alpha: 1)

    /// Кэш для rgb цветов
    static var colorCacheMap: [String: UIColor] = [:]

    /// Фабрика rgb цветов с кешированием
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        let colorKey = "\(red)\(green)\(blue)"
        if let color = colorCacheMap[colorKey] {
            return color
        }
        let newColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        colorCacheMap[colorKey] = newColor
        return newColor
    }
}
