// AnimatedCurrentLocationViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

final class AnimatedCurrentLocationViewController: UIViewController {
    private var locationMarker: GMSMarker?

    private let locationManager = CLLocationManager()

    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: 38.8879, longitude: -77.0200, zoom: 17)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    override func loadView() {
        mapView.settings.myLocationButton = false
        mapView.settings.indoorPicker = false
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup location services
        guard CLLocationManager.locationServicesEnabled() else {
            print("Please enable location services")
            return
        }

        if CLLocationManager.authorizationStatus() == .denied {
            print("Please authorize location services")
            return
        }

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
        locationManager.startUpdatingLocation()
    }
}

extension AnimatedCurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if CLLocationManager.authorizationStatus() == .denied {
            print("Please authorize location services")
            return
        }
        print("Unable to get current location. Error: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if let existingMaker = locationMarker {
            CATransaction.begin()
            CATransaction.setAnimationDuration(2.0)
            existingMaker.position = location.coordinate
            CATransaction.commit()
        } else {
            let marker = GMSMarker(position: location.coordinate)
            // Animated walker images derived from an www.angryanimator.com tutorial.
            // See: http://www.angryanimator.com/word/2010/11/26/tutorial-2-walk-cycle/
            let animationFrames = (1 ... 8).compactMap {
                UIImage(named: "step\($0)")
            }
            marker.icon = UIImage.animatedImage(with: animationFrames, duration: 0.8)
            // Taking into account walker's shadow.
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.97)
            marker.map = mapView
            locationMarker = marker
        }
        mapView.animate(with: GMSCameraUpdate.setTarget(location.coordinate, zoom: 17))
    }
}
