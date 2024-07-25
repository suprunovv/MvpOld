// FitBoundsViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class FitBoundsViewController: UIViewController {
    private let markerImageName = "glow-marker"

    private let anotherSydneyLocation = CLLocationCoordinate2D(
        latitude: -33.8683, longitude: 149.2086
    )

    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(target: .victoria, zoom: 4)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    // Creates a list of markers, adding the Sydney marker.
    private lazy var markers: [GMSMarker] = {
        // Adds default markers around Sydney.
        let sydneyMarker = GMSMarker(position: .sydney)
        sydneyMarker.title = "Sydney!"
        sydneyMarker.icon = UIImage(named: markerImageName)

        let anotherSydneyMarker = GMSMarker()
        anotherSydneyMarker.title = "Sydney 2!"
        anotherSydneyMarker.icon = UIImage(named: markerImageName)
        anotherSydneyMarker.position = anotherSydneyLocation
        return [sydneyMarker, anotherSydneyMarker]
    }()

    override func loadView() {
        mapView.delegate = self
        view = mapView

        // Creates a button that, when pressed, updates the camera to fit the bounds.
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Fit Bounds", style: .plain, target: self, action: #selector(fitBounds)
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for marker in markers {
            marker.map = mapView
        }
    }

    @objc func fitBounds() {
        var bounds = GMSCoordinateBounds()
        for marker in markers {
            bounds = bounds.includingCoordinate(marker.position)
        }
        guard bounds.isValid else { return }
        mapView.moveCamera(GMSCameraUpdate.fit(bounds, withPadding: 50))
    }
}

extension FitBoundsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.title = "Marker at: \(coordinate.latitude), \(coordinate.longitude)"
        marker.appearAnimation = .pop
        marker.map = mapView
        markers.append(marker)
    }
}
