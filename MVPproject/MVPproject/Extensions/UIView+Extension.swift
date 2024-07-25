// UIView+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Удобная работа с компонентами
extension UIView {
    /// Отключение ресайз маски у вью
    func disableAutoresizingMask() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// Добавление нескольких сабвью
    /// - Parameter subviews: перечисление вью
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { self.addSubview($0) }
    }
}
