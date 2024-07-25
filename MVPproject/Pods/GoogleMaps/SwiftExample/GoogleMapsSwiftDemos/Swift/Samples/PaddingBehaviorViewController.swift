// PaddingBehaviorViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class PaddingBehaviorViewController: UIViewController {
    private static let panoramaCoordinate: CLLocationCoordinate2D = .init(
        latitude: 40.761388, longitude: -73.978133
    )

    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: -33.868, longitude: 151.2086, zoom: 6)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.padding = UIEdgeInsets(top: 0, left: 20, bottom: 40, right: 60)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return mapView
    }()

    private lazy var panoramaView: GMSPanoramaView = .init()
    private lazy var statusLabel: UILabel = .init()
    private lazy var changeBehaviorButton: UIButton = .init(type: .system)
    private lazy var toggleViewButton: UIBarButtonItem = .init(
        title: "Toggle View", style: .plain, target: self, action: #selector(toggleViewType)
    )
    private lazy var toggleFrameButton: UIButton = .init(type: .system)
    var hasShrunk = false

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.frame = view.bounds
        view.addSubview(mapView)

        // Add status label.
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationHeight = navigationController?.navigationBar.frame.height ?? 0
        let topYOffset = statusBarHeight + navigationHeight
        statusLabel.frame = CGRect(x: 30, y: topYOffset, width: 0, height: 30)
        statusLabel.textColor = .brown
        statusLabel.textAlignment = .left
        statusLabel.text = "Behavior: Always"
        statusLabel.sizeToFit()

        // Add behavior modifier button.
        changeBehaviorButton.frame = CGRect(x: 30, y: 30 + topYOffset, width: 0, height: 0)
        changeBehaviorButton.setTitle("Next Behavior", for: .normal)
        changeBehaviorButton.sizeToFit()
        changeBehaviorButton.addTarget(self, action: #selector(nextBehavior), for: .touchUpInside)

        // Add frame animation button.
        navigationItem.rightBarButtonItem = toggleViewButton

        // Add change view type button.
        toggleFrameButton.frame = CGRect(x: 30, y: 60 + topYOffset, width: 0, height: 0)
        toggleFrameButton.setTitle("Animate Frame", for: .normal)
        toggleFrameButton.sizeToFit()
        toggleFrameButton.addTarget(self, action: #selector(toggleFrame), for: .touchUpInside)

        mapView.addSubview(statusLabel)
        mapView.addSubview(changeBehaviorButton)
        mapView.addSubview(toggleFrameButton)

        hasShrunk = false

        // Pre-load PanoramaView
        panoramaView = GMSPanoramaView.panorama(
            withFrame: view.bounds, nearCoordinate: PaddingBehaviorViewController.panoramaCoordinate
        )
        panoramaView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    @objc func toggleFrame() {
        let size = view.bounds.size
        let point = view.bounds.origin
        UIView.animate(withDuration: 2) { [unowned self] in
            if hasShrunk {
                mapView.frame = view.bounds
                panoramaView.frame = mapView.frame
            } else {
                mapView.frame = CGRect(
                    x: point.x, y: point.y, width: size.width / 2, height: size.height / 2
                )
                panoramaView.frame = mapView.frame
            }
            hasShrunk = !hasShrunk
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

    @objc func toggleViewType() {
        if view.subviews.contains(mapView) {
            mapView.removeFromSuperview()
            view.addSubview(panoramaView)
            panoramaView.addSubview(toggleFrameButton)
        } else {
            panoramaView.removeFromSuperview()
            view.addSubview(mapView)
            mapView.addSubview(toggleFrameButton)
        }
    }

    @objc func nextBehavior() {
        switch mapView.paddingAdjustmentBehavior {
        case .always:
            mapView.paddingAdjustmentBehavior = .automatic
            statusLabel.text = "Behavior: Automatic"
        case .automatic:
            mapView.paddingAdjustmentBehavior = .never
            statusLabel.text = "Behavior: Never"
        default:
            mapView.paddingAdjustmentBehavior = .always
            statusLabel.text = "Behavior: Always"
        }
    }
}
