// MarkersViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

// Sample code for adding a marker.
class MarkersViewController: UIViewController {
    private lazy var sydneyMarker = GMSMarker(
        position: CLLocationCoordinate2D(latitude: -33.8683, longitude: 151.2086)
    )

    private lazy var melbourneMarker = GMSMarker(
        position: CLLocationCoordinate2D(latitude: -37.81969, longitude: 144.966085)
    )

    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: -37.81969, longitude: 144.966085, zoom: 4)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    override func loadView() {
        view = mapView

        sydneyMarker.title = "Sydney"
        sydneyMarker.snippet = "Population: 4,605,992"
        sydneyMarker.isFlat = false
        sydneyMarker.rotation = 30
        print("sydneyMarker: \(sydneyMarker)")

        let australiaMarker = GMSMarker(
            position: CLLocationCoordinate2D(latitude: -27.994401, longitude: 140.07019)
        )
        australiaMarker.title = "Australia"
        australiaMarker.appearAnimation = .pop
        australiaMarker.isFlat = true
        australiaMarker.isDraggable = true
        australiaMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        australiaMarker.icon = UIImage(named: "australia")
        australiaMarker.map = mapView

        mapView.selectedMarker = sydneyMarker
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(tapAdd)
        )
    }

    @objc func tapAdd() {
        if sydneyMarker.map == nil {
            sydneyMarker.map = mapView
        } else {
            sydneyMarker.map = nil
        }
        melbourneMarker.title = "Melbourne"
        melbourneMarker.snippet = "Population: 4,169,103"
        melbourneMarker.map = mapView
    }
}
