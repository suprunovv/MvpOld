// CameraViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class CameraViewController: UIViewController {
    private let interval: TimeInterval = 1 / 30

    private let bearing: CLLocationDirection = 10

    private let angle: Double = 10

    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(target: .victoria, zoom: 20, bearing: 0, viewingAngle: 0)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    private var timer: Timer?

    override func loadView() {
        mapView.settings.zoomGestures = false
        mapView.settings.scrollGestures = false
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        view = mapView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Every 0.033 seconds, adjust the position of the camera.
        timer = Timer.scheduledTimer(
            timeInterval: interval, target: self, selector: #selector(moveCamera), userInfo: nil,
            repeats: true
        )
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        timer?.invalidate()
    }

    // Updates zoom and viewing angle, the map zoom out and the map appears in perspective, with
    // far-away features appearing smaller, and nearby features appearing larger.
    @objc func moveCamera() {
        let zoom = max(mapView.camera.zoom - 0.1, 17.5)
        let newPosition = GMSCameraPosition(
            target: mapView.camera.target, zoom: zoom, bearing: mapView.camera.bearing + bearing,
            viewingAngle: mapView.camera.viewingAngle + angle
        )
        mapView.animate(to: newPosition)
    }
}
