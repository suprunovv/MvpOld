// TileLayerViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

final class TileLayerViewController: UIViewController {
    private var selectedIndex = 0 {
        didSet {
            updateTileLayer()
        }
    }

    private var tileLayer: GMSURLTileLayer?

    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: 37.78318, longitude: -122.403874, zoom: 18)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let floorNames = ["1", "2", "3"]
        return UISegmentedControl(items: floorNames)
    }()

    override func loadView() {
        mapView.isBuildingsEnabled = false
        mapView.isIndoorEnabled = false
        view = mapView

        // The possible floors that might be shown.
        segmentedControl.selectedSegmentIndex = 0
        selectedIndex = 0
        navigationItem.titleView = segmentedControl

        // Listen to touch events on the UISegmentedControl, force initial update.
        segmentedControl.addTarget(self, action: #selector(changeFloor), for: .valueChanged)
        changeFloor()
    }

    @objc func changeFloor() {
        guard segmentedControl.selectedSegmentIndex != selectedIndex else { return }
        selectedIndex = segmentedControl.selectedSegmentIndex
    }

    func updateTileLayer() {
        // Clear existing tileLayer, if any.
        tileLayer?.map = nil
        // Create a new GMSTileLayer with the new floor choice.
        tileLayer = GMSURLTileLayer(urlConstructor: { (x: UInt, y: UInt, zoom: UInt) -> URL? in
            URL(
                string:
                "https://www.gstatic.com/io2010maps/tiles/9/L\(self.selectedIndex + 1)_\(zoom)_\(x)_\(y).png"
            )
        })
        tileLayer?.map = mapView
    }
}
