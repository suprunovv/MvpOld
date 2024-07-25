// LoadImageService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол для сервиса загрузки изображений
protocol LoadImageServiceProtocol {
    /// Метод для получения Data по URL
    func loadImage(url: URL?, completion: @escaping (Data?, URLResponse?, Error?) -> ())
}

/// Сервис загрузки изображения
final class LoadImageService: LoadImageServiceProtocol {
    func loadImage(url: URL?, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfig.urlCache = nil
        let session = URLSession(configuration: sessionConfig)
        guard let url = url else { return }
        session.dataTask(with: url, completionHandler: completion).resume()
    }
}

/// Прокси для получения изображений
final class LoadImageProxy: LoadImageServiceProtocol {
    private var service: LoadImageServiceProtocol?

    init(service: LoadImageServiceProtocol?) {
        self.service = service
    }

    func loadImage(url: URL?, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let url = url else { return }
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return
        }

        let imageUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        if fileManager.fileExists(atPath: imageUrl.path) {
            do {
                let imageData = try Data(contentsOf: imageUrl)
                completion(imageData, nil, nil)
                return
            } catch {
                completion(nil, nil, error)
                return
            }
        } else {
            service?.loadImage(url: url) { data, response, error in
                if let data = data {
                    do {
                        try data.write(to: imageUrl)
                        completion(data, response, error)
                    } catch {
                        completion(nil, response, error)
                    }
                } else {
                    completion(nil, response, error)
                }
            }
        }
    }
}
