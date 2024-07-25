// MarkerInfoWindowViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

final class MarkerInfoWindowViewController: UIViewController {
    private let sydneyMarker = GMSMarker(
        position: CLLocationCoordinate2D(latitude: -33.8683, longitude: 151.2086)
    )

    private let melbourneMarker = GMSMarker(
        position: CLLocationCoordinate2D(latitude: -37.81969, longitude: 144.966085)
    )

    private let brisbaneMarker = GMSMarker(
        position: CLLocationCoordinate2D(latitude: -27.4710107, longitude: 153.0234489)
    )

    private lazy var contentView: UIImageView = .init(image: UIImage(named: "aeroplane"))

    override func loadView() {
        let cameraPosition = GMSCameraPosition(latitude: -37.81969, longitude: 144.966085, zoom: 4)
        let mapView = GMSMapView(frame: .zero, camera: cameraPosition)
        mapView.delegate = self
        view = mapView

        sydneyMarker.title = "Sydney"
        sydneyMarker.snippet = "Population: 4,605,992"
        sydneyMarker.map = mapView

        melbourneMarker.title = "Melbourne"
        melbourneMarker.snippet = "Population: 4,169,103"
        melbourneMarker.map = mapView

        brisbaneMarker.title = "Brisbane"
        brisbaneMarker.snippet = "Population: 2,189,878"
        brisbaneMarker.map = mapView
    }
}

extension MarkerInfoWindowViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if marker == sydneyMarker {
            return contentView
        }
        return nil
    }

    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        if marker == brisbaneMarker {
            return contentView
        }
        return nil
    }

    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        showToast(message: "Info window for marker \(marker.title ?? "") closed.")
    }

    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        showToast(message: "Info window for marker \(marker.title ?? "") long pressed.")
    }
}

extension UIViewController {
    func showToast(message: String) {
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(
            toast, animated: true,
            completion: {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                    toast.dismiss(animated: true)
                }
            }
        )
    }
}
