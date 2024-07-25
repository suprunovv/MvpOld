// GroundOverlayViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

final class GroundOverlayViewController: UIViewController {
    override func loadView() {
        let southWest = CLLocationCoordinate2D(latitude: 40.712216, longitude: -74.22655)
        let northEast = CLLocationCoordinate2D(latitude: 40.773941, longitude: -74.12544)
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)

        // Choose the midpoint of the coordinate to focus the camera on.
        let newark = GMSGeometryInterpolate(southWest, northEast, 0.5)
        let cameraPosition = GMSCameraPosition(target: newark, zoom: 12, bearing: 0, viewingAngle: 45)
        let mapView = GMSMapView(frame: .zero, camera: cameraPosition)
        mapView.delegate = self
        view = mapView

        // Add the ground overlay, centered in Newark, NJ
        let groundOverlay = GMSGroundOverlay()
        // Image from http://www.lib.utexas.edu/maps/historical/newark_nj_1922.jpg
        groundOverlay.icon = UIImage(named: "newark_nj_1922.jpg")
        groundOverlay.isTappable = true
        groundOverlay.position = newark
        groundOverlay.bounds = overlayBounds
        groundOverlay.map = mapView
    }
}

extension GroundOverlayViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        guard let groundOverlay = overlay as? GMSGroundOverlay else { return }
        groundOverlay.opacity = Float.random(in: 0.5 ..< 1)
    }
}
