// StyledMapViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class StyledMapViewController: UIViewController {
    lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: -33.868, longitude: 151.2086, zoom: 12)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    override func loadView() {
        view = mapView

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Style", style: .plain, target: self, action: #selector(changeMapStyle)
        )

        updateUI(style: .retro)
    }

    func updateUI(style: SampleMapStyle) {
        navigationItem.title = "\(style)"
        mapView.mapStyle = style.mapStyle
    }

    @objc func changeMapStyle(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "Select map style", message: nil, preferredStyle: .actionSheet
        )
        for style in SampleMapStyle.allCases {
            alert.addAction(
                UIAlertAction(
                    title: style.description, style: .default
                ) { _ in
                    self.updateUI(style: style)
                }
            )
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = sender
        present(alert, animated: true)
    }
}
