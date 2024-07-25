// UIFont+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Расширение для шрифта Verdana
extension UIFont {
    /// Кеш для шрифтов
    static var fontCacheMap: [String: UIFont] = [:]

    /// Шрифт вердана с жирностью 400
    /// - Parameter ofSize: размер шрифта
    /// - Returns: опциональный шрифт вердана
    static func verdana(ofSize size: CGFloat) -> UIFont? {
        getFont(name: "Verdana", size: size)
    }

    /// Шрифт вердана с жирностью 700
    /// - Parameter ofSize: размер шрифта
    /// - Returns: опциональный жирный шрифт вердана
    static func verdanaBold(ofSize size: CGFloat) -> UIFont? {
        getFont(name: "Verdana-Bold", size: size)
    }

    private static func getFont(name: String, size: CGFloat) -> UIFont? {
        let fontKey = "\(name)\(size)"
        if let font = fontCacheMap[fontKey] {
            return font
        }
        let newFont = UIFont(name: name, size: size)
        fontCacheMap[fontKey] = newFont
        return newFont
    }
}
