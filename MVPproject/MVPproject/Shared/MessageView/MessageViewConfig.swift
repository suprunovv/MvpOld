// MessageViewConfig.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Конфигурация сообщения
struct MessageViewConfig {
    /// Иконка
    let icon: UIImage?
    /// Заголовок
    let title: String?
    /// Описание
    let description: String
    /// с/без кнопки перезагрузки
    let withReload: Bool

    init(icon: UIImage?, title: String? = nil, description: String, withReload: Bool = false) {
        self.icon = icon
        self.title = title
        self.description = description
        self.withReload = withReload
    }
}
