// MapLayerViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class MapLayerViewController: UIViewController {
    private let duration: TimeInterval = 2

    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(target: .victoria, zoom: 4)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    override func loadView() {
        mapView.isMyLocationEnabled = true
        view = mapView

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Fly to My Location", style: .plain, target: self, action: #selector(tapMyLocation)
        )
    }

    @objc func tapMyLocation() {
        guard let location = mapView.myLocation, CLLocationCoordinate2DIsValid(location.coordinate)
        else {
            return
        }
        mapView.layer.cameraLatitude = location.coordinate.latitude
        mapView.layer.cameraLongitude = location.coordinate.longitude
        mapView.layer.cameraBearing = 0

        // Access the GMSMapLayer directly to modify the following properties with a
        // specified timing function and duration.
        addMapViewAnimation(key: kGMSLayerCameraLatitudeKey, toValue: location.coordinate.latitude)
        addMapViewAnimation(key: kGMSLayerCameraLongitudeKey, toValue: location.coordinate.longitude)
        addMapViewAnimation(key: kGMSLayerCameraBearingKey, toValue: 0)

        // Fly out to the minimum zoom and then zoom back to the current zoom!
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: kGMSLayerCameraZoomLevelKey)
        keyFrameAnimation.duration = duration
        let zoom = mapView.camera.zoom
        keyFrameAnimation.values = [zoom, kGMSMinZoomLevel, zoom]
        mapView.layer.add(keyFrameAnimation, forKey: kGMSLayerCameraZoomLevelKey)
    }

    func addMapViewAnimation(key: String, toValue: Double) {
        let animation = CABasicAnimation(keyPath: key)
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.toValue = toValue
        mapView.layer.add(animation, forKey: key)
    }
}
