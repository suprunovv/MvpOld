// Strings+Generated.swift
// Copyright © RoadMap. All rights reserved.

// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum SwiftGenStrings {
    enum AuthScreen {
        /// Localazible.strings
        ///   MVPproject
        ///
        ///   Created by MacBookPro on 28.03.2024.
        static let emailLabelText = SwiftGenStrings.tr(
            "Localazible",
            "AuthScreen.EmailLabelText",
            fallback: "Email Address"
        )
        /// Enter Email Address
        static let emailTextFiledPlaceholder = SwiftGenStrings.tr(
            "Localazible",
            "AuthScreen.emailTextFiledPlaceholder",
            fallback: "Enter Email Address"
        )
        /// Please check the accuracy of the
        /// entered credentials.
        static let errorLabelText = SwiftGenStrings.tr(
            "Localazible",
            "AuthScreen.errorLabelText",
            fallback: "Please check the accuracy of the \nentered credentials."
        )
        /// Incorrect format
        static let incorrectEmailText = SwiftGenStrings.tr(
            "Localazible",
            "AuthScreen.incorrectEmailText",
            fallback: "Incorrect format"
        )
        /// You entered the wrong password
        static let incorrectPasswordText = SwiftGenStrings.tr(
            "Localazible",
            "AuthScreen.incorrectPasswordText",
            fallback: "You entered the wrong password"
        )
        /// Login
        static let loginTitle = SwiftGenStrings.tr("Localazible", "AuthScreen.loginTitle", fallback: "Login")
        /// Password
        static let passwordLabelText = SwiftGenStrings.tr(
            "Localazible",
            "AuthScreen.passwordLabelText",
            fallback: "Password"
        )
        /// Enter Password
        static let passwordTextFiledPlaceholder = SwiftGenStrings.tr(
            "Localazible",
            "AuthScreen.passwordTextFiledPlaceholder",
            fallback: "Enter Password"
        )
    }

    enum Category {
        /// Start typing text
        static let emptyPageDescription = SwiftGenStrings.tr(
            "Localazible",
            "Category.emptyPageDescription",
            fallback: "Start typing text"
        )
        /// Failed to load data
        static let errorMessageDescription = SwiftGenStrings.tr(
            "Localazible",
            "Category.errorMessageDescription",
            fallback: "Failed to load data"
        )
        /// Try entering your query differently
        static let notFoundDescription = SwiftGenStrings.tr(
            "Localazible",
            "Category.notFoundDescription",
            fallback: "Try entering your query differently"
        )
        /// Nothing found
        static let notFoundTitle = SwiftGenStrings.tr(
            "Localazible",
            "Category.notFoundTitle",
            fallback: "Nothing found"
        )
        /// Search recipes
        static let searchBarPlaceholder = SwiftGenStrings.tr(
            "Localazible",
            "Category.searchBarPlaceholder",
            fallback: "Search recipes"
        )
    }

    enum DetailViewController {
        /// Try reloading the page
        static let emptyDataDescription = SwiftGenStrings.tr(
            "Localazible",
            "DetailViewController.emptyDataDescription",
            fallback: "Try reloading the page"
        )
        /// Nothing found
        static let emptyDataTitle = SwiftGenStrings.tr(
            "Localazible",
            "DetailViewController.emptyDataTitle",
            fallback: "Nothing found"
        )
        /// Failed to load data
        static let errorMessageDescription = SwiftGenStrings.tr(
            "Localazible",
            "DetailViewController.errorMessageDescription",
            fallback: "Failed to load data"
        )
    }

    enum EnergyView {
        enum TitleType {
            /// Carbohydrates
            static let carbohydrates = SwiftGenStrings.tr(
                "Localazible",
                "EnergyView.TitleType.carbohydrates",
                fallback: "Carbohydrates"
            )
            /// Enerc kcal
            static let enerckcal = SwiftGenStrings.tr(
                "Localazible",
                "EnergyView.TitleType.enerckcal",
                fallback: "Enerc kcal"
            )
            /// Fats
            static let fats = SwiftGenStrings.tr("Localazible", "EnergyView.TitleType.fats", fallback: "Fats")
            /// Proteins
            static let proteins = SwiftGenStrings.tr(
                "Localazible",
                "EnergyView.TitleType.proteins",
                fallback: "Proteins"
            )
        }

        enum Unit {
            /// kcal
            static let calories = SwiftGenStrings.tr("Localazible", "EnergyView.Unit.calories", fallback: "kcal")
            /// g
            static let gram = SwiftGenStrings.tr("Localazible", "EnergyView.Unit.gram", fallback: "g")
        }
    }

    enum RecipesScreen {
        /// Recipes
        static let titleText = SwiftGenStrings.tr("Localazible", "RecipesScreen.titleText", fallback: "Recipes")
    }

    enum ShimerView {
        /// shimmerAnimation
        static let gadientKey = SwiftGenStrings.tr("Localazible", "ShimerView.gadientKey", fallback: "shimmerAnimation")
    }

    enum SortButtonView {
        /// Calories
        static let calloriesTitle = SwiftGenStrings.tr(
            "Localazible",
            "SortButtonView.calloriesTitle",
            fallback: "Calories"
        )
        /// Time
        static let timeTitle = SwiftGenStrings.tr("Localazible", "SortButtonView.timeTitle", fallback: "Time")
    }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension SwiftGenStrings {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BundleToken.self)
        #endif
    }()
}

// swiftlint:enable convenience_type
