// FixedPanoramaViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class FixedPanoramaViewController: UIViewController {
    override func loadView() {
        let panoramaView = GMSPanoramaView(frame: .zero)
        panoramaView.moveNearCoordinate(.newYork)
        panoramaView.camera = GMSPanoramaCamera(heading: 180, pitch: -10, zoom: 0)
        panoramaView.orientationGestures = false
        panoramaView.navigationGestures = false
        panoramaView.navigationLinksHidden = true
        view = panoramaView
    }
}
