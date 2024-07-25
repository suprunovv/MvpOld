// FrameRateViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class FrameRateViewController: UIViewController {
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: -33.868, longitude: 151.2086, zoom: 6)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    private lazy var statusTextView: UITextView = .init()

    override func loadView() {
        view = mapView

        statusTextView.text = ""
        statusTextView.textAlignment = .center
        statusTextView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        statusTextView.isEditable = false
        view.addSubview(statusTextView)
        statusTextView.sizeToFit()

        // Add a button toggling through modes.
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .play, target: self, action: #selector(changeFrameRate)
        )

        updateStatus()

        statusTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusTextView.leftAnchor.constraint(equalTo: view.leftAnchor),
            statusTextView.rightAnchor.constraint(equalTo: view.rightAnchor),
            statusTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
        ])
        NSLayoutConstraint.activate([
            statusTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    @objc func changeFrameRate() {
        mapView.preferredFrameRate = nextFrameRate()
        updateStatus()
    }

    func nextFrameRate() -> GMSFrameRate {
        switch mapView.preferredFrameRate {
        case .powerSave:
            return .conservative
        case .conservative:
            return .maximum
        default:
            return .powerSave
        }
    }

    func updateStatus() {
        statusTextView.text = "Preferred frame rate: \(mapView.preferredFrameRate.name)"
    }
}

extension GMSFrameRate {
    var name: String {
        switch self {
        case .powerSave:
            return "PowerSave"
        case .conservative:
            return "Conservative"
        default:
            return "Maximum"
        }
    }
}
