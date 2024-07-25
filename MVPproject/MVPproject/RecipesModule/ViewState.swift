// ViewState.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Стейт вью
enum ViewState<T> {
    /// Поисходит загрузка данных
    case loading
    /// Данные загружены
    case data(T)
    /// Данные не загружены
    case noData
    /// Ошибка при попытке запроса
    case error(Error)
}
