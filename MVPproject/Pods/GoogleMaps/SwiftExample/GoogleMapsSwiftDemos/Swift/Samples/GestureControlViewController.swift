// GestureControlViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class GestureControlViewController: UIViewController {
    private let holderHeight: CGFloat = 60
    private let zoomLabelInset: CGFloat = 16

    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: -25.5605, longitude: 133.605097, zoom: 3)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    private lazy var zoomSwitch: UISwitch = .init(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)

        let holder = UIView(frame: .zero)
        holder.backgroundColor = UIColor(white: 1, alpha: 0.8)
        view.addSubview(holder)

        let zoomLabel = UILabel(frame: .zero)
        zoomLabel.text = "Zoom gestures"
        zoomLabel.font = .boldSystemFont(ofSize: 18)
        holder.addSubview(zoomLabel)

        // Control zooming.
        holder.addSubview(zoomSwitch)
        zoomSwitch.addTarget(self, action: #selector(toggleZoom), for: .valueChanged)
        zoomSwitch.isOn = true

        for item in [mapView, holder, zoomLabel, zoomSwitch] {
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            holder.heightAnchor.constraint(equalToConstant: holderHeight),
            holder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            holder.widthAnchor.constraint(equalTo: view.widthAnchor),
            zoomLabel.leftAnchor.constraint(equalTo: holder.leftAnchor, constant: zoomLabelInset),
            zoomLabel.centerYAnchor.constraint(equalTo: holder.centerYAnchor),
            zoomSwitch.rightAnchor.constraint(equalTo: holder.rightAnchor, constant: -zoomLabelInset),
            zoomSwitch.centerYAnchor.constraint(
                equalTo: holder.centerYAnchor
            ),
        ])
        NSLayoutConstraint.activate([
            holder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    @objc func toggleZoom() {
        mapView.settings.zoomGestures = zoomSwitch.isOn
    }
}
