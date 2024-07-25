// RecipesScreenTests.swift
// Copyright © RoadMap. All rights reserved.

import XCTest

/// Тест экрана с выбором категории рецептов
class RecipesScreenTests: XCTestCase {
    private enum Constants {
        static let validEmail = "Suprunov@gmail.com"
        static let validPassword = "4815162342"
    }

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
    }

    override func tearDown() async throws {
        app = nil
    }

    /// Тест скрола вверх и вниз
    func testScrollUpDown() {
        app.launch()
        login()
        sleep(3)
        app.collectionViews.containing(.other, identifier: "Vertical scroll bar, 2 pages").element.swipeUp()
        app.collectionViews.containing(.other, identifier: "Vertical scroll bar, 2 pages").element.swipeDown()
    }

    func testTouchCell() {
        app.launch()
        login()
        sleep(3)
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: "Chicken").element.tap()
    }

    func testTabBar() {
        app.launch()
        login()
        sleep(2)
        app.tabBars["Tab Bar"].buttons["Favorites"].tap()
        app.tabBars["Tab Bar"].buttons["Profile"].tap()
        app.tabBars["Tab Bar"].buttons["Recipes"].tap()
    }

    func testCheckText() {
        app.launch()
        login()
        sleep(5)
        chekText(stringId: "Salad")
        chekText(stringId: "Soup")
        chekText(stringId: "Recipes")
        chekText(stringId: "Chicken")
        chekText(stringId: "Meat")
        chekText(stringId: "Fish")
        chekText(stringId: "Side dish")
        chekText(stringId: "Drinks")
        app.collectionViews.containing(.other, identifier: "Vertical scroll bar, 2 pages").element.swipeUp()
        chekText(stringId: "Pancake")
        chekText(stringId: "Desserts")
    }

    func chekText(stringId: String) {
        guard app.staticTexts[stringId].exists else {
            XCTFail("Такого текста нет \(stringId)")
            return
        }
    }

    private func login() {
        let emailTextFiled = app.textFields["Enter Email Address"]
        emailTextFiled.tap()
        emailTextFiled.typeText(Constants.validEmail)
        let passwordTextFiled = app.textFields["Enter Password"]
        passwordTextFiled.tap()
        passwordTextFiled.typeText(Constants.validPassword)
        app.buttons["Login"].tap()
    }
}
