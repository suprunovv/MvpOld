// MapTypesViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class MapTypesViewController: UIViewController {
    private let types: [GMSMapViewType] = [.normal, .satellite, .hybrid, .terrain]

    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(target: .sydney, zoom: 12)
        return GMSMapView(frame: .zero, camera: camera)
    }()

    private lazy var segmentedControl: UISegmentedControl = .init(items: types.map { "\($0)" })

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.addTarget(self, action: #selector(changeMapType), for: .valueChanged)
        navigationItem.titleView = segmentedControl
    }

    @objc func changeMapType(_ sender: UISegmentedControl) {
        mapView.mapType = types[sender.selectedSegmentIndex]
    }
}

extension GMSMapViewType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .normal:
            return "Normal"
        case .satellite:
            return "Satellite"
        case .hybrid:
            return "Hybrid"
        case .terrain:
            return "Terrain"
        default:
            return ""
        }
    }
}
