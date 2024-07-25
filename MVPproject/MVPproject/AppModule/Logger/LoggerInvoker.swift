// LoggerInvoker.swift
// Copyright © RoadMap. All rights reserved.

/// Базовый сервис логирования
class BaseLoggerInvoker<L: Logger> {
    fileprivate var commands: [LogCommand<L.Log>] = []
    fileprivate var isForceExecution = false

    func log(_ command: LogCommand<L.Log>) {
        addLogCommand(command)
    }

    func forceExecution() {
        isForceExecution.toggle()
        executeCommandsIfNeeded()
        isForceExecution.toggle()
    }

    private func addLogCommand(_ command: LogCommand<L.Log>) {
        commands.append(command)
        executeCommandsIfNeeded()
    }

    fileprivate func executeCommandsIfNeeded() {}

    deinit {
        forceExecution()
    }
}

/// Сервис контролирующий логирование в текстовый файл
final class TxtFileLoggerInvoker: BaseLoggerInvoker<TxtFileLogger> {
    static let shared = TxtFileLoggerInvoker()

    private let batchSize = 2
    private let logger = TxtFileLogger()

    override fileprivate func executeCommandsIfNeeded() {
        guard isForceExecution || commands.count >= batchSize else { return }
        commands.forEach { logger.writeLog($0.log) }
        commands.removeAll()
    }
}
