// MarkerEventsViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

final class MarkerEventsViewController: UIViewController {
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: -37.81969, longitude: 144.966085, zoom: 4)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    private var melbourneMarker = GMSMarker(
        position: CLLocationCoordinate2D(latitude: -37.81969, longitude: 144.966085)
    )

    override func loadView() {
        let sydneyMarker = GMSMarker(
            position: CLLocationCoordinate2D(latitude: -33.8683, longitude: 151.2086)
        )
        sydneyMarker.map = mapView
        melbourneMarker.map = mapView
        mapView.delegate = self
        view = mapView
    }
}

extension MarkerEventsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if marker == melbourneMarker {
            return UIImageView(image: UIImage(named: "Icon"))
        }
        return nil
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // Animate to the marker
        CATransaction.begin()
        CATransaction.setAnimationDuration(3)
        let camera = GMSCameraPosition(target: marker.position, zoom: 8, bearing: 50, viewingAngle: 60)
        mapView.animate(to: camera)
        CATransaction.commit()

        // Melbourne marker has a InfoWindow so return false to allow markerInfoWindow to
        // fire. Also check that the marker isn't already selected so that the InfoWindow
        // doesn't close.
        if marker == melbourneMarker, mapView.selectedMarker != melbourneMarker {
            return false
        }
        return true
    }
}
