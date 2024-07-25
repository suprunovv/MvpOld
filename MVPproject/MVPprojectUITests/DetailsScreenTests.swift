// DetailsScreenTests.swift
// Copyright © RoadMap. All rights reserved.

import XCTest

///
class DetailsScreenTests: XCTestCase {
    private enum Constants {
        static let validEmail = "Suprunov@gmail.com"
        static let validPassword = "4815162342"
        static let search = "baked Chicken"
    }

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testNavigationButtons() {
        app.launch()
        login()
        sleep(3)
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: "Chicken").element.tap()
        sleep(2)
        let tableView = app.tables["tableView"]
        tableView.staticTexts["peasant chicken"].tap()
        sleep(1)
        let navigationBar = XCUIApplication().navigationBars["MVPproject.DetailView"]
        let bookmarkiconButton = navigationBar.buttons["bookmarkBarIcon"]
        bookmarkiconButton.tap()
        bookmarkiconButton.tap()
        let button = navigationBar.children(matching: .button).element(boundBy: 1)
        button.tap()
        let backButton = navigationBar.buttons["arrowBack"]
        backButton.tap()
        sleep(1)
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
