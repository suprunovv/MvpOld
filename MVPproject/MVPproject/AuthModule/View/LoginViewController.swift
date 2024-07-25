// LoginViewController.swift
// Copyright © RoadMap. All rights reserved.

import TextFileds
import UIKit

/// Протокол представления логина
protocol LoginViewProtocol: AnyObject {
    /// Метод обновляющий UI скрывающий/открывающий пароль
    func updatePasswordSecuredUI(_ isSecured: Bool, image: UIImage?)
    /// Метод вызывает переход на следующий экран
    func goToSecondView()
    /// Метод запускает индикатор загрузки
    func startActivityIndicator()
    /// Метод останавливает индикатор загрузки
    func stopActivityIndicator()
    /// Метод убирает текст у кнопки Login
    func hideTextLoginButton()
    /// Метод возвращает текст кнопке Login
    func returnTextLoginButton()
    /// Метод показывает вьшку с предупреждением что вход не выполнен
    func presentErrorLoginView()
    /// Метод скрывает вьюшку с предупреждением что вход не выполнен
    func hideErrorLoginView()
    /// Установка ошибки валидации email
    func setEmailValidationError(_ error: String?)
    /// Установка ошибки валидации password
    func setPasswordValidationError(_ error: String?)
    /// Сброс ошибки валидации email
    func clearPasswordValidationError()
    /// Сброс ошибки валидации password
    func clearEmailValidationError()
    // Метод скрывает клавиатуру по нажатию на любую область экрана
    func hideKeyboardOnTap()
}

/// Вью экрана входа
final class LoginViewController: UIViewController {
    // MARK: - Visual Compontnts

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(SwiftGenStrings.AuthScreen.loginTitle, for: .normal)
        button.backgroundColor = .greenDarkButton
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .verdana(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 28)
        label.text = SwiftGenStrings.AuthScreen.loginTitle
        label.textColor = .grayText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 18)
        label.text = SwiftGenStrings.AuthScreen.emailLabelText
        label.textColor = .grayText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let incorrectEmailLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 12)
        label.text = SwiftGenStrings.AuthScreen.incorrectEmailText
        label.textColor = .redError
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let incorrectPasswordLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 12)
        label.text = SwiftGenStrings.AuthScreen.incorrectPasswordText
        label.textColor = .redError
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 18)
        label.text = SwiftGenStrings.AuthScreen.passwordLabelText
        label.textColor = .grayText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailTextFiled: UITextField = {
        let textFiled = TextFileds()
        textFiled.setPlaceholder(model: .init(placeholder: SwiftGenStrings.AuthScreen.emailTextFiledPlaceholder))
        return textFiled
    }()

    private let passwordTextFiled: UITextField = {
        let textFiled = TextFileds()
        textFiled.setPlaceholder(model: .init(placeholder: SwiftGenStrings.AuthScreen.passwordTextFiledPlaceholder))
        textFiled.clearButtonMode = .never
        textFiled.rightViewMode = .always
        return textFiled
    }()

    private let securePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.eyeSlashImage, for: .normal)
        button.tintColor = .systemGray
        return button
    }()

    private let emailImageView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.emailImage, for: .normal)
        button.tintColor = .systemGray
        return button
    }()

    private let passwordImageView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.passwordImage, for: .normal)
        button.tintColor = .systemGray
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let errorLoginView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .redError
        view.isHidden = true
        return view
    }()

    private let errorLoginLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = SwiftGenStrings.AuthScreen.errorLabelText
        return label
    }()

    private lazy var emailStackView: UIStackView = {
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextFiled])
        emailStackView.axis = .vertical
        emailStackView.distribution = .fill
        emailStackView.spacing = 6
        emailStackView.alpha = 0
        view.addSubview(emailStackView)
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        let trailingEmailStack = emailStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        trailingEmailStack.isActive = true
        emailStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.89).isActive = true
        emailStackView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        emailStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 137).isActive = true
        emailTextFiled.heightAnchor.constraint(equalToConstant: 50).isActive = true

        return emailStackView
    }()

    private lazy var passwordStackView: UIStackView = {
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextFiled])
        passwordStackView.axis = .vertical
        passwordStackView.distribution = .fill
        passwordStackView.spacing = 6
        passwordStackView.alpha = 0
        view.addSubview(passwordStackView)
        passwordStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordStackView.heightAnchor.constraint(equalToConstant: 88),
            passwordStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 23),
            passwordTextFiled.heightAnchor.constraint(equalToConstant: 50)
        ])
        return passwordStackView
    }()

    var presenter: LoginPresenterProtocol?

    private lazy var bottomLoginButtonConstant = self.loginButton.bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
        constant: -37
    )

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        presenter?.screenLoaded()
    }

    // MARK: Private methods

    private func setView() {
        view.backgroundColor = .white
        setupGradient()
        setTitleLabelConstraints()
        setTextFieldsStackViewsAnimation()
        setLoginButtonConstraints()
        setSecureButton()
        setEmailFieldLeftImageView()
        setPasswordFieldLeftImageView()
        addTargetButtons()
        addTextFiledDelegate()
        setIncorrectEmailLabelConstraint()
        setIncorrectPasswordLabelConstraint()
        entryKeyboard()
        hideKeyboard()
        addTapToView()
        setIndicatorConstraint()
        setErrorLoginViewConstraint()
        setErrorLabelConstraint()
    }

    private func setErrorLoginViewConstraint() {
        view.addSubview(errorLoginView)
        errorLoginView.heightAnchor.constraint(equalToConstant: 87).isActive = true
        errorLoginView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.89).isActive = true
        errorLoginView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        errorLoginView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83).isActive = true
    }

    private func setErrorLabelConstraint() {
        errorLoginView.addSubview(errorLoginLabel)
        errorLoginLabel.leadingAnchor.constraint(equalTo: errorLoginView.leadingAnchor, constant: 15).isActive = true
        errorLoginLabel.topAnchor.constraint(equalTo: errorLoginView.topAnchor, constant: 16).isActive = true
    }

    private func setIndicatorConstraint() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: -5).isActive = true
    }

    private func entryKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    private func hideKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func addTextFiledDelegate() {
        emailTextFiled.delegate = self
        passwordTextFiled.delegate = self
    }

    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1).cgColor,
            UIColor.systemGray3.cgColor
        ]
        view.layer.insertSublayer(gradient, at: 0)
    }

    private func setTitleLabelConstraints() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 82)
        ])
    }

    private func setTextFieldsStackViewsAnimation() {
        UIView.animate(withDuration: 2) { [weak self] in
            self?.emailStackView.alpha = 1
        }
        UIView.animate(withDuration: 2) { [weak self] in
            self?.passwordStackView.alpha = 1
        }
    }

    private func setLoginButtonConstraints() {
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            bottomLoginButtonConstant
        ])
    }

    private func setIncorrectEmailLabelConstraint() {
        view.addSubview(incorrectEmailLabel)
        NSLayoutConstraint.activate([
            incorrectEmailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            incorrectEmailLabel.topAnchor.constraint(equalTo: emailStackView.bottomAnchor)
        ])
    }

    private func setIncorrectPasswordLabelConstraint() {
        view.addSubview(incorrectPasswordLabel)
        NSLayoutConstraint.activate([
            incorrectPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            incorrectPasswordLabel.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor)
        ])
    }

    private func setSecureButton() {
        let view = makeTextFieldView(wrappedView: securePasswordButton)
        passwordTextFiled.rightView = view
    }

    private func setEmailFieldLeftImageView() {
        let view = makeTextFieldView(wrappedView: emailImageView)
        emailTextFiled.leftView = view
    }

    private func setPasswordFieldLeftImageView() {
        let view = makeTextFieldView(wrappedView: passwordImageView)
        passwordTextFiled.leftView = view
    }

    private func makeTextFieldView(wrappedView: UIView) -> UIView {
        let view = UIView()
        view.addSubview(wrappedView)
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        wrappedView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wrappedView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }

    private func addTargetButtons() {
        loginButton.addTarget(self, action: #selector(tappLoginButton), for: .touchUpInside)
        securePasswordButton.addTarget(self, action: #selector(secureButtonTapped), for: .touchUpInside)
    }

    private func addTapToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToView))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func tapToView() {
        presenter?.hideViewKeyboard()
    }

    @objc private func secureButtonTapped() {
        presenter?.toggleSecureButton()
    }

    @objc private func tappLoginButton() {
        let password = passwordTextFiled.text ?? ""
        presenter?.validatePassword(password: password)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                bottomLoginButtonConstant.constant = -keyboardHeight.height - 20
            }
        }
    }

    @objc func keyboardWillHide() {
        bottomLoginButtonConstant.constant = -37
    }
}

// MARK: - LoginViewController + LoginViewProtocol

extension LoginViewController: LoginViewProtocol {
    func hideErrorLoginView() {
        errorLoginView.isHidden = true
    }

    func presentErrorLoginView() {
        errorLoginView.isHidden = false
    }

    func hideTextLoginButton() {
        loginButton.setTitle("", for: .normal)
    }

    func returnTextLoginButton() {
        loginButton.setTitle(SwiftGenStrings.AuthScreen.loginTitle, for: .normal)
    }

    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }

    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }

    func updatePasswordSecuredUI(_ isSecured: Bool, image: UIImage?) {
        securePasswordButton.setImage(image, for: .normal)
        passwordTextFiled.isSecureTextEntry = isSecured
    }

    func setEmailValidationError(_ error: String?) {
        emailTextFiled.layer.borderColor = UIColor.redError.cgColor
        incorrectEmailLabel.isHidden = false
        incorrectEmailLabel.text = error
        emailLabel.textColor = .redError
    }

    func clearEmailValidationError() {
        emailTextFiled.layer.borderColor = UIColor.systemGray.cgColor
        incorrectEmailLabel.isHidden = true
        emailLabel.textColor = .grayText
    }

    func setPasswordValidationError(_ error: String?) {
        passwordTextFiled.layer.borderColor = UIColor.redError.cgColor
        incorrectPasswordLabel.isHidden = false
        incorrectPasswordLabel.text = error
        passwordLabel.textColor = .redError
    }

    func clearPasswordValidationError() {
        passwordTextFiled.layer.borderColor = UIColor.systemGray.cgColor
        incorrectPasswordLabel.isHidden = true
        passwordTextFiled.textColor = .grayText
        passwordLabel.textColor = .grayText
    }

    func hideKeyboardOnTap() {
        view.endEditing(true)
    }

    func goToSecondView() {
        passwordTextFiled.textColor = .systemGray
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == emailTextFiled {
            let text = emailTextFiled.text ?? ""
            presenter?.validateEmail(email: text)
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTextFiled:
            emailTextFiled.becomeFirstResponder()
        case passwordTextFiled:
            passwordTextFiled.becomeFirstResponder()
        default: break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextFiled:
            passwordTextFiled.becomeFirstResponder()
        case passwordTextFiled:
            passwordTextFiled.resignFirstResponder()
        default: break
        }
        return true
    }
}
