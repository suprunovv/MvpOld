// MapViewPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MapPresenterProtocol: AnyObject {
    /// Показать детали
    func showDetailView(model: MarkersData)
    /// Закрыть экран
    func dismiss()
}

final class MapViewPresenter {
    private weak var view: MapViewProtocol?
    private weak var coordinator: ProfileCoordinator?

    init(view: MapViewProtocol, coordinator: ProfileCoordinator) {
        self.view = view
        self.coordinator = coordinator
    }
}

extension MapViewPresenter: MapPresenterProtocol {
    func showDetailView(model: MarkersData) {
        view?.showDetail(model: model)
    }

    func dismiss() {
        view?.closeScreen()
    }
}
