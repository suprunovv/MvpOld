// NetworkServiceTest.swift
// Copyright © RoadMap. All rights reserved.

//
//  NetworkServiceTest.swift
//  Recipes
//
//  Created by MacBookPro on 03.04.2024.
//
@testable import MVPproject
import XCTest

/// Тестирование сервиса с запросами
class NetworkServiceTest: XCTestCase {
    private enum Constants {
        static let uri = "http://www.edamam.com/ontologies/edamam.owl#recipe_7bf4a371c6884d809682a72808da7dc2"
        static let uriError = "errorUri"
    }

    var network: NetworkServiceProtocol!
    override func setUpWithError() throws {
        network = NetworkService()
    }

    override func tearDownWithError() throws {
        network = nil
    }

    func testNetwork() throws {
        let networkServiceExpactation = XCTestExpectation()
        network.getRecipesByCategory(CategoryRequestDTO(
            category: .init(type: .chicken, name: "", imageName: "")
        )) { result in
            switch result {
            case let .failure(error):
                XCTAssertNil(error)
            case let .success(data):
                XCTAssertNotNil(data)
            }
            networkServiceExpactation.fulfill()
        }
        wait(for: [networkServiceExpactation], timeout: 10)
    }

    func testNetworkUri() throws {
        let networkServiceExpactation = XCTestExpectation()
        network.getRecipesDetailsByURI(Constants.uri) { result in
            switch result {
            case let .success(data):
                XCTAssertNotNil(data)
            case let .failure(error):
                XCTAssertNil(error)
            }
            networkServiceExpactation.fulfill()
        }
        wait(for: [networkServiceExpactation], timeout: 10)
    }

    func testNetworkError() throws {
        let networkServiceExpactation = XCTestExpectation()
        network.getRecipesByCategory(CategoryRequestDTO(
            category: .init(type: .empty, name: "", imageName: "")
        )) { result in
            switch result {
            case let .failure(error):
                XCTAssertNotNil(error)
            case let .success(data):
                XCTAssertNil(data)
            }
            networkServiceExpactation.fulfill()
        }
        wait(for: [networkServiceExpactation], timeout: 10)
    }

    func testNetworkUriError() throws {
        let networkServiceExpactation = XCTestExpectation()
        network.getRecipesDetailsByURI(Constants.uriError) { result in
            switch result {
            case let .success(data):
                XCTAssertNil(data)
            case let .failure(error):
                XCTAssertNotNil(error)
            }
            networkServiceExpactation.fulfill()
        }
        wait(for: [networkServiceExpactation], timeout: 10)
    }
}
