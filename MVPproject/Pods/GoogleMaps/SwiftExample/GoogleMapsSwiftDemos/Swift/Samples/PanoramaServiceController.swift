// PanoramaServiceController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

final class PanoramaServiceController: UIViewController {
    private let markerLocation = CLLocationCoordinate2D.sydney

    private var mySubview = UIView(frame: .zero)
    private var statusLabel = UILabel(frame: .zero)
    private var result = UITextView(frame: .zero)

    private var panoService: GMSPanoramaService?
    private var requestCount = 0
    private var responseCount = 0

    override func loadView() {
        navigationController?.navigationBar.isTranslucent = false
        view = mySubview

        statusLabel.alpha = 1.0
        statusLabel.backgroundColor = .blue
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        statusLabel.text = "Service Never Called"
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(result)
        result.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.topAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            result.topAnchor.constraint(equalTo: statusLabel.bottomAnchor),
            result.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            result.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            result.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        if panoService == nil {
            panoService = GMSPanoramaService()
            statusLabel.text = "Service initialized \(panoService?.description ?? "nil")"
        }

        requestCount += 1
        panoService?.requestPanoramaNearCoordinate(
            markerLocation,
            radius: 300, // meters
            source: .outside
        ) {
            pano, err in
            self.responseCount += 1
            self.statusLabel.text =
                "Callback invoked \(self.responseCount) time(s) out of \(self.requestCount) requests."

            if let pano = pano {
                self.result.text = [
                    "id: \(pano.panoramaID)",
                    "#neighbors: \(pano.links.count)",
                    "coordinate: \(pano.coordinate)",
                    "description: \(pano.description)",
                    "debugDescription: \(pano.debugDescription)",
                ].joined(separator: "\n")
            } else {
                self.result.text = "<nil>"
            }
        }
        super.viewWillAppear(animated)
    }
}
