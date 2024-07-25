// LoginViewPresenter.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол презентера логина
protocol LoginPresenterProtocol: AnyObject {
    /// Метод получает пароль и валидирует его
    func validatePassword(password: String)
    /// Метод валидации email
    func validateEmail(email: String)
    /// Метод скрывает/показывает пароль и меняет картику кнопки с глазком
    func toggleSecureButton()
    /// Метод обрабатывает нажатие на вью и вызывает у нее метод скрывающий клавиатуру
    func hideViewKeyboard()
    /// Экран загружен
    func screenLoaded()
}

/// Презентер для экрана логин
final class LoginPresenter {
    private weak var authCoordinator: AuthCoordinator?
    private weak var view: LoginViewProtocol?
    private var email: String?
    private var password: String?

    private var isPasswordSecured = true
    private var isValid = (password: false, login: false)
    private let loginFormValidator = LoginFormValidator()
    private var timer = Timer()

    init(view: LoginViewProtocol, coordinator: AuthCoordinator) {
        self.view = view
        authCoordinator = coordinator
    }

    private func startTimer(timeInterval: TimeInterval, handler: @escaping (Timer) -> Void) {
        timer = Timer.scheduledTimer(
            withTimeInterval: timeInterval,
            repeats: false,
            block: handler
        )
    }

    private func processLoginError() {
        view?.startActivityIndicator()
        view?.hideTextLoginButton()
        startTimer(timeInterval: 2) { [weak self] timer in
            self?.view?.stopActivityIndicator()
            self?.view?.returnTextLoginButton()
            self?.view?.presentErrorLoginView()
            timer.invalidate()
            self?.startTimer(timeInterval: 1) { [weak self] timer in
                self?.view?.hideErrorLoginView()
                timer.invalidate()
            }
        }
    }

    private func processLoginValide() {
        view?.startActivityIndicator()
        view?.hideTextLoginButton()
        startTimer(timeInterval: 2) { [weak self] timer in
            self?.view?.stopActivityIndicator()
            self?.view?.returnTextLoginButton()
            timer.invalidate()
            self?.authCoordinator?.didLogin()
        }
    }

    private func validatePersonData(password: String, email: String) {
        let personData = PersonData(email: email, password: password)
        Originator.shared.restoreFromUserDefaults()
        if Originator.shared.memento?.isFirstLoading == true {
            AuthService.shared.login(personData)
            Originator.shared.saveToUserDefaults()
            processLoginValide()
            return
        }

        guard let credentials = AuthService.shared.restoreCredentials(), credentials == personData else {
            processLoginError()
            return
        }
        processLoginValide()
    }
}

// MARK: - LoginPresenter + LoginPresenterProtocol

extension LoginPresenter: LoginPresenterProtocol {
    func screenLoaded() {
        TxtFileLoggerInvoker.shared.log(.viewScreen(ScreenInfo(title: "Login")))
    }

    func hideViewKeyboard() {
        view?.hideKeyboardOnTap()
    }

    func validatePassword(password: String) {
        let validationError = loginFormValidator.validatePassword(password)
        if let validationError = validationError {
            view?.setPasswordValidationError(validationError)
            isValid.password = false
        } else {
            view?.clearPasswordValidationError()
            isValid.password = true
        }

        if isValid == (true, true) {
            self.password = password
            guard let password = self.password, let email = email else { return }
            FavoriteRecipes.shared.getRecipes()
            validatePersonData(password: password, email: email)
        }
    }

    func validateEmail(email: String) {
        let validationError = loginFormValidator.validateEmail(email)
        if let validationError = validationError {
            view?.setEmailValidationError(validationError)
            isValid.login = false
        } else {
            view?.clearEmailValidationError()
            isValid.login = true
            self.email = email
        }
    }

    func toggleSecureButton() {
        isPasswordSecured.toggle()
        view?.updatePasswordSecuredUI(isPasswordSecured, image: isPasswordSecured ? .eyeSlashImage : .eyeFill)
    }
}
