// PanoramaViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class PanoramaViewController: UIViewController {
    private let markerLocation = CLLocationCoordinate2D(latitude: 40.761455, longitude: -73.977814)
    private var panoramaView = GMSPanoramaView(frame: .zero)
    private var statusLabel = UILabel(frame: .zero)
    private var configured = false

    override func loadView() {
        navigationController?.navigationBar.isTranslucent = false
        panoramaView.moveNearCoordinate(.newYork)
        panoramaView.backgroundColor = .gray
        panoramaView.delegate = self
        view = panoramaView

        statusLabel.alpha = 0.0
        statusLabel.backgroundColor = .blue
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.topAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension PanoramaViewController: GMSPanoramaViewDelegate {
    func panoramaView(_ panoramaView: GMSPanoramaView, didMove camera: GMSPanoramaCamera) {
        print("Camera:\(camera.orientation.heading), \(camera.orientation.pitch), \(camera.zoom)")
    }

    func panoramaView(_ view: GMSPanoramaView, didMoveTo panorama: GMSPanorama?) {
        if configured { return }
        let marker = GMSMarker(position: markerLocation)
        marker.icon = GMSMarker.markerImage(with: .purple)
        marker.panoramaView = panoramaView
        let heading = GMSGeometryHeading(.newYork, markerLocation)
        panoramaView.camera = GMSPanoramaCamera(heading: heading, pitch: 0, zoom: 1)
        configured = true
    }

    func panoramaViewDidStartRendering(_ panoramaView: GMSPanoramaView) {
        statusLabel.alpha = 0.8
        statusLabel.text = "Rendering"
    }

    func panoramaViewDidFinishRendering(_ panoramaView: GMSPanoramaView) {
        statusLabel.alpha = 0
    }
}
