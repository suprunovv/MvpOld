// TrafficMapViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class TrafficMapViewController: UIViewController {
    private var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: -33.868, longitude: 151.2086, zoom: 12)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isTrafficEnabled = true
        return mapView
    }()

    override func loadView() {
        view = mapView
    }
}
