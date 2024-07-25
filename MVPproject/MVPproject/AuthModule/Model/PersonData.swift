// PersonData.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель данных пользователя
struct PersonData {
    // Email Пользователя
    private(set) var email: String
    // Пароль Пользователя
    private(set) var password: String
}

// MARK: - PersonData + Equatable

extension PersonData: Equatable {
    static func == (lhs: PersonData, rhs: PersonData) -> Bool {
        lhs.email == rhs.email && lhs.password == rhs.password
    }
}
