// SnapshotReadyViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class SnapshotReadyViewController: UIViewController {
    lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: -33.868, longitude: 151.2086, zoom: 6)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    private lazy var statusLabel: UILabel = .init()
    private lazy var waitButton: UIBarButtonItem = .init()
    private var isAwaitingSnapshot = false {
        didSet {
            waitButton.isEnabled = !isAwaitingSnapshot
            if isAwaitingSnapshot {
                waitButton.title = "Waiting"
            } else {
                waitButton.title = "Wait for snapshot"
            }
        }
    }

    override func loadView() {
        view = mapView
        navigationController?.navigationBar.isTranslucent = false

        mapView.delegate = self

        // Add status label, initially hidden.
        statusLabel.alpha = 0
        statusLabel.autoresizingMask = .flexibleWidth
        statusLabel.backgroundColor = .blue
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            statusLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])

        // Add a wait button to signify on the next SnapshotReady event, a screenshot of the map will
        // be taken.
        waitButton = UIBarButtonItem(
            title: "Wait for snapshot", style: .plain, target: self, action: #selector(didTapWait)
        )
        navigationItem.rightBarButtonItem = waitButton
    }

    @objc func didTapWait() {
        isAwaitingSnapshot = true
    }

    func takeSnapshot() {
        // Take a snapshot of the map.
        UIGraphicsBeginImageContextWithOptions(mapView.bounds.size, true, 0)
        mapView.drawHierarchy(in: mapView.bounds, afterScreenUpdates: true)
        let mapSnapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Put snapshot image into an UIImageView and overlay on top of map.
        let imageView = UIImageView(image: mapSnapshot)
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.layer.borderWidth = 10
        mapView.addSubview(imageView)

        // Remove imageView after 1 second.
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1
        ) {
            UIView.animate(
                withDuration: 1,
                animations: {
                    imageView.alpha = 0
                },
                completion: { _ in
                    imageView.removeFromSuperview()
                }
            )
        }
    }
}

extension SnapshotReadyViewController: GMSMapViewDelegate {
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        if isAwaitingSnapshot {
            isAwaitingSnapshot = false
            takeSnapshot()
        }

        statusLabel.alpha = 0.8
        statusLabel.text = "Snapshot Ready"
        // Remove status label after 1 second.
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1
        ) {
            self.statusLabel.alpha = 0
        }
    }
}
