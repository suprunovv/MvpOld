// ErrorDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Ошибка с сервера
struct ErrorDTO: Codable {
    /// Сообщение ошибки
    let message: String
}
