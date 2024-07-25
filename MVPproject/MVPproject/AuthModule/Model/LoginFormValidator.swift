// LoginFormValidator.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Валидатор формы входа
struct LoginFormValidator {
    func validateEmail(_ email: String) -> String? {
        guard email.count >= 6 else {
            return "Too short email"
        }
        guard email.contains("@"), email.contains(".") else {
            return "Invalid email"
        }
        return nil
    }

    func validatePassword(_ password: String) -> String? {
        guard password.count > 8 else {
            return "Too short password"
        }
        return nil
    }
}
