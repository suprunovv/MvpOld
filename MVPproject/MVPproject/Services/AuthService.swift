// AuthService.swift
// Copyright © RoadMap. All rights reserved.

import Keychain

/// Сервис авторизации приложения
final class AuthService {
    private enum Constants {
        static let emailKey = "email"
        static let passwordKey = "password"
    }

    /// Состояние приложения
    enum State {
        /// Не авторизован
        case unauthorized
        /// Пользователь залогинен
        case loggedIn
    }

    /// Общий истанс на все приложение
    static let shared = AuthService()

    private(set) var state: State = .unauthorized

    func login(_ user: PersonData) {
        state = .loggedIn
        saveCredentials(user)
    }

    func restoreCredentials() -> PersonData? {
        let email = Keychain.load(Constants.emailKey)
        let password = Keychain.load(Constants.passwordKey)
        if let email = email, let password = password {
            return PersonData(email: email, password: password)
        }

        return nil
    }

    private func saveCredentials(_ credentials: PersonData) {
        _ = Keychain.save(credentials.email, forKey: Constants.emailKey)
        _ = Keychain.save(credentials.password, forKey: Constants.passwordKey)
    }
}
