// VisibleRegionViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class VisibleRegionViewController: UIViewController {
    static let overlayHeight: CGFloat = 140
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: -37.81969, longitude: 144.966085, zoom: 4)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.padding = UIEdgeInsets(
            top: 0, left: 0, bottom: VisibleRegionViewController.overlayHeight, right: 0
        )
        return mapView
    }()

    private lazy var overlay: UIView = {
        let overlay = UIView(frame: .zero)
        overlay.backgroundColor = UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 0.5)
        return overlay
    }()

    private lazy var flyInButton: UIBarButtonItem = .init(
        title: "Toggle Overlay", style: .plain, target: self, action: #selector(didTapToggleOverlay)
    )

    override func loadView() {
        view = mapView
        navigationItem.rightBarButtonItem = flyInButton

        let overlayFrame = CGRect(
            x: 0, y: -VisibleRegionViewController.overlayHeight, width: 0,
            height: VisibleRegionViewController.overlayHeight
        )
        overlay.frame = overlayFrame
        overlay.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(overlay)
    }

    @objc func didTapToggleOverlay() {
        let padding = mapView.padding
        UIView.animate(withDuration: 2) { [unowned self] in
            let size = view.bounds.size
            if padding.bottom == 0 {
                overlay.frame = CGRect(
                    x: 0, y: size.height - VisibleRegionViewController.overlayHeight, width: size.width,
                    height: VisibleRegionViewController.overlayHeight
                )
                mapView.padding = UIEdgeInsets(
                    top: 0, left: 0, bottom: VisibleRegionViewController.overlayHeight, right: 0
                )
            } else {
                overlay.frame = CGRect(
                    x: 0, y: mapView.bounds.size.height, width: size.width, height: 0
                )
                mapView.padding = .zero
            }
        }
    }
}
