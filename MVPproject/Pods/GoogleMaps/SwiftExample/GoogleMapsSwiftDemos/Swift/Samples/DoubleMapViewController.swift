// DoubleMapViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class DoubleMapViewController: UIViewController {
    private lazy var sanFranciscoCamera = GMSCameraPosition(
        latitude: 37.7847, longitude: -122.41, zoom: 5
    )
    private lazy var mapView: GMSMapView = {
        let mapView = GMSMapView(frame: .zero, camera: sanFranciscoCamera)
        return mapView
    }()

    private lazy var boundMapView: GMSMapView = {
        let mapView = GMSMapView(frame: .zero, camera: sanFranciscoCamera)
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        boundMapView.settings.scrollGestures = false
        boundMapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boundMapView)

        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            boundMapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            boundMapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            boundMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            boundMapView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
        ])
    }
}

extension DoubleMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let previousCamera = boundMapView.camera
        boundMapView.camera = GMSCameraPosition(
            target: position.target, zoom: previousCamera.zoom, bearing: previousCamera.bearing,
            viewingAngle: previousCamera.viewingAngle
        )
    }
}
