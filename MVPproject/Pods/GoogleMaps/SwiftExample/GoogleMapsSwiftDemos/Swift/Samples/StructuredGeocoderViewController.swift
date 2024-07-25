// StructuredGeocoderViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

// Sample code for GeoCoder service.
class StructuredGeocoderViewController: UIViewController {
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

extension StructuredGeocoderViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        // On a long press, reverse geocode this location.
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult() else {
                let errorMessage = error.map { String(describing: $0) } ?? "<no error>"
                print(
                    """
                    Could not reverse geocode point (\(coordinate.latitude), \(coordinate.longitude)): \
                     \(errorMessage)
                    """
                )
                return
            }
            print("Geocoder result: \(address)")
            let marker = GMSMarker(position: address.coordinate)
            marker.appearAnimation = .pop
            marker.map = mapView
            marker.title = address.thoroughfare

            var snippet = ""
            if let subLocality = address.subLocality {
                snippet.append("subLocality: \(subLocality)\n")
            }
            if let locality = address.locality {
                snippet.append("subLocality: \(locality)\n")
            }
            if let administrativeArea = address.administrativeArea {
                snippet.append("administrativeArea: \(administrativeArea)\n")
            }
            if let country = address.country {
                snippet.append("country: \(country)\n")
            }
            marker.snippet = snippet
        }
    }
}
