// AuthScreelTests.swift
// Copyright © RoadMap. All rights reserved.

import XCTest

///
class AuthScreelTests: XCTestCase {
    private enum Constants {
        static let validEmail = "Suprunov@gmail.com"
        static let validPassword = "4815162342"
        static let invalidEmail = "Suprunov"
        static let shortEmail = "su"
        static let shortPassword = "5512"
        static let errorPassword = "12135135235"
    }

    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    /// Проверка некорректного email
    func testInvalidEmail() {
        app.launch()
        let emailTextFiled = app.textFields["Enter Email Address"]
        emailTextFiled.tap()
        emailTextFiled.typeText(Constants.invalidEmail)
        app.textFields["Enter Password"].tap()
        chekText(stringId: "Invalid email")
    }

    /// Проверка короткого Email
    func testShortEmail() {
        app.launch()
        let emailTextFiled = app.textFields["Enter Email Address"]
        emailTextFiled.tap()
        emailTextFiled.typeText(Constants.shortEmail)
        app.textFields["Enter Password"].tap()
        chekText(stringId: "Too short email")
    }

    /// Проверка короткого password
    func testShortPassword() {
        app.launch()
        let passwordTextField = app.textFields["Enter Password"]
        passwordTextField.tap()
        passwordTextField.typeText(Constants.shortPassword)
        app.buttons["Login"].tap()
        chekText(stringId: "Too short password")
    }

    func testInvalidLogin() {
        app.launch()
        let emailTextFiled = app.textFields["Enter Email Address"]
        emailTextFiled.tap()
        emailTextFiled.typeText(Constants.validEmail)

        let passwordTextFiled = app.textFields["Enter Password"]
        passwordTextFiled.tap()
        passwordTextFiled.typeText(Constants.errorPassword)
        app.buttons["Login"].tap()
        sleep(2)
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other)
        XCTAssertTrue(element.element.exists)
    }

    /// Проверка успешного входа
    func testValidLogin() {
        app.launch()
        let emailTextFiled = app.textFields["Enter Email Address"]
        emailTextFiled.tap()
        emailTextFiled.typeText(Constants.validEmail)

        let passwordTextFiled = app.textFields["Enter Password"]
        passwordTextFiled.tap()
        passwordTextFiled.typeText(Constants.validPassword)
        app.buttons["Login"].tap()
    }

    private func chekText(stringId: String) {
        guard app.staticTexts[stringId].exists else {
            XCTFail("Такого текста нет \(stringId)")
            return
        }
    }
}
