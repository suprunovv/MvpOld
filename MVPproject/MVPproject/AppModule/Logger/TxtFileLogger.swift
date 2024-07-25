// TxtFileLogger.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Логгер записывающий сообщения в файл
final class TxtFileLogger: Logger {
    // MARK: - Types

    typealias Log = String

    // MARK: - Private Properties

    private let logDirectory = "Recipely_logs"
    private let logFileBaseName = "Recipely_logs"
    private let sessionId = UUID()

    private var logFileName: String {
        "\(logFileBaseName)_\(sessionId).txt"
    }

    // MARK: - Initializers

    init() {
        createFolderIfNeeded()
    }

    // MARK: - Public Methods

    func writeLog(_ log: Log) {
        guard let logFileUrl = getLogFileUrl() else { return }
        let logData = (try? String(contentsOf: logFileUrl)) ?? ""
        let data = Data("\(logData)\n\(log)".utf8)
        try? data.write(to: logFileUrl)
    }

    // MARK: - Private Methods

    private func createFolderIfNeeded() {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent(logDirectory).path else { return }

        if FileManager.default.fileExists(atPath: path) { return }
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
    }

    private func getLogFileUrl() -> URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent(logDirectory).appendingPathComponent(logFileName) else { return nil }
        return path
    }
}
