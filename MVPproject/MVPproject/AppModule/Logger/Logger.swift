// Logger.swift
// Copyright © RoadMap. All rights reserved.

/// Протокол логгера, который будет записывать данные
protocol Logger: AnyObject {
    associatedtype Log: Codable
    /// Метод логирования сообщения
    func writeLog(_ log: Log)
}
