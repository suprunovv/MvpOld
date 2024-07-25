// LoadImageServiceTest.swift
// Copyright © RoadMap. All rights reserved.

//
//  LoadImageServiceTest.swift
//  MVPprojectTests
//
//  Created by MacBookPro on 03.04.2024.
//
@testable import MVPproject
import XCTest

/// Тестирование сервиса загрузки изображений
class LoadImageServiceTest: XCTestCase {
    private enum Constants {
        static let imageUrl =
            "https://avatars.dzeninfra.ru/get-zen_doc/271828/pub_653900788395506b995699d5_653bae1f0eb21624a233b692/scale_1200"
        static let imageUrlError = "sdvsdvs"
    }

    var loadImageService: LoadImageServiceProtocol!

    override func setUpWithError() throws {
        loadImageService = LoadImageService()
    }

    override func tearDownWithError() throws {
        loadImageService = nil
    }

    func testLoadImage() throws {
        let url = URL(string: Constants.imageUrl)
        let loadImageExpectation = XCTestExpectation()
        loadImageService.loadImage(url: url) { data, _, error in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            loadImageExpectation.fulfill()
        }
        wait(for: [loadImageExpectation], timeout: 10)
    }

    func testLoadImageError() throws {
        let url = URL(string: Constants.imageUrlError)
        let loadImageExpectation = XCTestExpectation()
        loadImageService.loadImage(url: url) { data, _, error in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
            loadImageExpectation.fulfill()
        }
        wait(for: [loadImageExpectation], timeout: 10)
    }
}
