// GeocoderViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

// Sample code for GeoCoder service.
class GeocoderViewController: UIViewController {
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: -33.868, longitude: 151.2086, zoom: 12)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    private lazy var geocoder = GMSGeocoder()

    override func loadView() {
        view = mapView
        mapView.delegate = self
    }
}

extension GeocoderViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        // On a long press, reverse geocode this location.
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult() else {
                let errorMessage = error.map { String(describing: $0) } ?? "<no error>"
                print(
                    "Could not reverse geocode point (\(coordinate.latitude), \(coordinate.longitude)): \(errorMessage)"
                )
                return
            }
            print("Geocoder result: \(address)")
            let marker = GMSMarker(position: address.coordinate)
            marker.appearAnimation = .pop
            marker.map = mapView

            guard let lines = address.lines, let title = lines.first else { return }
            marker.title = title
            if lines.count > 1 {
                marker.snippet = lines[1]
            }
        }
    }
}
