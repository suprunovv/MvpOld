// IndoorViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class IndoorViewController: UIViewController {
    let mapStyleOptions: [SampleMapStyle] = [.retro, .grayscale, .night, .normal]
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: 37.78318, longitude: -122.403874, zoom: 18)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.settings.myLocationButton = true
        return mapView
    }()

    override func loadView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Style", style: .plain, target: self, action: #selector(changeMapStyle(_:))
        )

        view = mapView
    }

    func alertAction(_ sampleMapStyle: SampleMapStyle) -> UIAlertAction {
        UIAlertAction(title: sampleMapStyle.description, style: .default) { [weak self] _ in
            self?.mapView.mapStyle = sampleMapStyle.mapStyle
        }
    }

    @objc func changeMapStyle(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "Select map style", message: nil, preferredStyle: .actionSheet
        )
        for style in mapStyleOptions {
            alert.addAction(alertAction(style))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.popoverPresentationController?.barButtonItem = sender
        present(alert, animated: true, completion: nil)
    }
}
