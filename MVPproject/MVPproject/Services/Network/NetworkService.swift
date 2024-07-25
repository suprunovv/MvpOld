// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Таргет приложения
final class Target {
    static var isMokeTarget: Bool {
        #if Mock
        true
        #else
        false
        #endif
    }
}

/// Имя мок файла или пустой
enum MokeFileName: String {
    case posts
    case empty
}

/// Протокол сервиса сети
protocol NetworkServiceProtocol {
    /// Запрос рецептов по категории
    func getRecipesByCategory(
        _ categoryRequestDTO: CategoryRequestDTO,
        completion: @escaping (Result<[Recipe], NetworkError>) -> ()
    )
    /// Запрос деталей рецепта
    func getRecipesDetailsByURI(_ uri: String, completion: @escaping (Result<Recipe, NetworkError>) -> Void)
}

/// Сервис запроса данных из сети
final class NetworkService: NetworkServiceProtocol {
    private enum QueryParameters {
        static let dishType = "dishType"
        static let health = "health"
        static let query = "q"
        static let uri = "uri"
        static let deatailsURIPath = "by-uri"
    }

    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    func getRecipesByCategory(
        _ categoryRequestDTO: CategoryRequestDTO,
        completion: @escaping (Result<[Recipe], NetworkError>) -> ()
    ) {
        var queryItems = [URLQueryItem(name: QueryParameters.dishType, value: categoryRequestDTO.dishTypeValue)]
        if let healthValue = categoryRequestDTO.healthValue {
            queryItems.append(URLQueryItem(name: QueryParameters.health, value: healthValue))
        }
        if let queryValue = categoryRequestDTO.queryValue {
            queryItems.append(URLQueryItem(name: QueryParameters.query, value: queryValue))
        }

        let endpoint = RecipelyEndpoint(queryItems: queryItems)

        makeRequest(endpoint) { result in
            DispatchQueue.main.async {
                switch result {
                case let .failure(error):
                    return completion(.failure(.network(error.localizedDescription)))
                case let .success(data):
                    do {
                        let recipesDto = try self.decoder.decode(RecipesResponseDTO.self, from: data)
                        let recipes = recipesDto.hits.compactMap { Recipe(dto: $0.recipe) }
                        if recipes.isEmpty {
                            completion(.failure(.emptyData))
                        } else {
                            completion(.success(recipes))
                        }
                    } catch {
                        completion(.failure(.parsing))
                    }
                }
            }
        }
    }

    func getRecipesDetailsByURI(_ uri: String, completion: @escaping (Result<Recipe, NetworkError>) -> Void) {
        let uriItem = URLQueryItem(name: QueryParameters.uri, value: uri)
        let endpoint = RecipelyEndpoint(path: QueryParameters.deatailsURIPath, queryItems: [uriItem])
        makeRequest(endpoint) { result in
            DispatchQueue.main.async {
                switch result {
                case let .failure(error):
                    return completion(.failure(error))
                case let .success(data):
                    do {
                        let detailsDto = try JSONDecoder().decode(ReecipeDetailsResponseDTO.self, from: data)
                        guard let recipeDetailsDto = detailsDto.hits.first?.recipe,
                              let recipe = Recipe(dto: recipeDetailsDto)
                        else {
                            return completion(.failure(.emptyData))
                        }
                        return completion(.success(recipe))
                    } catch {
                        return completion(.failure(.network(error.localizedDescription)))
                    }
                }
            }
        }
    }

    private func makeRequest(_ endpoint: Endpoint, then handler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL.makeURL(endpoint.url?.absoluteString ?? "", mokeFileName: .posts) else {
            return
        }

        print(url.absoluteString)

        let task = session.dataTask(with: url) { data, _, error in
            if let error = error {
                return handler(.failure(.network(error.localizedDescription)))
            }
            guard let data = data else {
                return handler(.failure(.emptyData))
            }

            handler(.success(data))
        }

        task.resume()
    }
}

extension URL {
    static func makeURL(_ urlString: String, mokeFileName: MokeFileName?) -> URL? {
        var newURL = URL(string: urlString)
        guard Target.isMokeTarget else { return newURL }
        var fileName = mokeFileName?.rawValue ?? ""
        if fileName.isEmpty {
            fileName = fileName.replacingOccurrences(of: "/", with: "_")
        }
        let bundleURL = Bundle.main.url(forResource: fileName, withExtension: "json")
        guard let bundleURL = bundleURL else {
            let errorText = "Отсутствует моковый файл: \(fileName).json"
            debugPrint(errorText)
            return nil
        }
        newURL = bundleURL
        return newURL
    }
}
