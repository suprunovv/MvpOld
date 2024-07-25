// Coordinator.swift
// Copyright © RoadMap. All rights reserved.

/// Протокол описывающий объекты, которые выступают в роли Координатора
protocol Coordinator: AnyObject {
    /// Дочерние координаторы
    var childCoordinators: [Coordinator] { get set }
    /// Запуск flow
    func start()
}

/// Расширение протокола Координатор с базовой имплементацией методов добавления/удаления дочерних координаторов
extension Coordinator {
    /// Добавление координатора как дочернего
    /// - Parameter coordinator: дочерний координатор
    func add(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    /// Удаление координатора из дочерних
    /// - Parameter coordinator: дочерний координатор
    func remove(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
