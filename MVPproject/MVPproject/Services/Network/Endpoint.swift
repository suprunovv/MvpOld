// Endpoint.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол удаленного ресурса
protocol Endpoint {
    /// Создание удаленного ресурса с параметрами
    init(queryItems: [URLQueryItem])
    /// Создание удаленного ресурса с параметрами и дополнительным путем
    init(path: String, queryItems: [URLQueryItem])
    /// URL удаленного ресурса
    var url: URL? { get }
}

/// Удаленный ресурс рецептов
struct RecipelyEndpoint: Endpoint {
    var url: URL? {
        var urlComponents = makeBaseURLComponents()
        urlComponents.queryItems = authQueryItems + requiredQueryItems + queryItems
        if #available(iOS 16.0, *) {
            return urlComponents.url?.appendingPathComponent(path)
        } else {
            return urlComponents.url?.appendingPathComponent(path)
        }
    }

    private let queryItems: [URLQueryItem]
    private let path: String
    private let authQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "app_id", value: "cea69cbe"),
        URLQueryItem(name: "app_key", value: "f0dbdf0e1de381a3491ca0757b29bdf6")
    ]
    private let requiredQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "type", value: "public")
    ]

    init(queryItems: [URLQueryItem] = []) {
        self.queryItems = queryItems
        path = ""
    }

    init(path: String, queryItems: [URLQueryItem]) {
        self.queryItems = queryItems
        self.path = path
    }

    private func makeBaseURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/api/recipes/v2"
        return components
    }
}
