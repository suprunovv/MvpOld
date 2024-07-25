// CategoryScreenTests.swift
// Copyright © RoadMap. All rights reserved.

import XCTest

///
class CategoryScreenTests: XCTestCase {
    private enum Constants {
        static let validEmail = "Suprunov@gmail.com"
        static let validPassword = "4815162342"
        static let search = "Baked Chicken"
        static let errorSearch = "sdvsdvsdv"
    }

    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testSearch() {
        app.launch()
        login()
        sleep(3)
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: "Chicken").element.tap()
        let searchBar = app.searchFields["Search recipes"]
        searchBar.tap()
        searchBar.typeText(Constants.search)
        sleep(1)
        let tableView = app.tables["tableView"]
        tableView.staticTexts[Constants.search].tap()
    }

    func testSortedButtons() {
        app.launch()
        login()
        sleep(3)
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: "Chicken").element.tap()
        app.buttons["Calories"].tap()
        sleep(1)
        app.buttons["Calories"].tap()
        sleep(1)
        app.buttons["Calories"].tap()
        sleep(1)
        app.buttons["Time"].tap()
        sleep(1)
        app.buttons["Time"].tap()
        sleep(1)
        app.buttons["Time"].tap()
    }

    func testText() {
        app.launch()
        login()
        sleep(3)
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: "Chicken").element.tap()
        let searchBar = app.searchFields["Search recipes"]
        searchBar.tap()
        searchBar.typeText(Constants.errorSearch)
        sleep(1)
        chekText(stringId: "Nothing found")
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

    func chekText(stringId: String) {
        guard app.staticTexts[stringId].exists else {
            XCTFail("Такого текста нет \(stringId)")
            return
        }
    }
}
