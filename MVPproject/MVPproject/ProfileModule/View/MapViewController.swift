// MapViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

/// Протокол для экрана с картой
protocol MapViewProtocol: AnyObject {
    func closeScreen()
    func showDetail(model: MarkersData)
}

/// Экран с гугл картой
final class MapViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let title = "Our Partners"
        static let description = "You can get gifts and discounts from \nour partners"
        static let ok = "Ok"
    }

    // MARK: - Visual Components

    private let titleLable: UILabel = {
        let label = UILabel()
        label.text = Constants.title
        label.textColor = .black
        label.font = .verdanaBold(ofSize: 20)
        label.textAlignment = .center
        label.disableAutoresizingMask()
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.xMark, for: .normal)
        button.tintColor = .black
        button.disableAutoresizingMask()
        return button
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 18)
        label.numberOfLines = 2
        label.textColor = .black
        label.text = Constants.description
        label.disableAutoresizingMask()
        return label
    }()

    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.ok, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = .verdana(ofSize: 18)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.disableAutoresizingMask()
        return button
    }()

    private let coordinateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setImage(UIImage.paperplane, for: .normal)
        button.tintColor = .black
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.cornerRadius = 26
        button.disableAutoresizingMask()
        return button
    }()

    var presenter: MapPresenterProtocol?

    private let mapView = GMSMapView()

    private let markers = MarkersData.getAllMarcers()

    private let coordinate = CLLocationCoordinate2D(latitude: 59.2239, longitude: 39.884)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVeiw()
    }

    private func setupVeiw() {
        view.backgroundColor = .white
        setCloseButton()
        setTitle()
        setMapView()
        setDescriptionLabel()
        setOkButton()
        configureMap()
        setCoordinateButton()
    }

    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 12)
        mapView.camera = camera
        mapView.delegate = self
        setMarkers()
    }

    private func setMarkers() {
        for marker in markers {
            addMarker(model: marker, color: .red)
        }
    }

    private func setCoordinateButton() {
        mapView.addSubview(coordinateButton)
        coordinateButton.heightAnchor.constraint(equalToConstant: 52).activate()
        coordinateButton.widthAnchor.constraint(equalToConstant: 52).activate()
        coordinateButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -14).activate()
        coordinateButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -14).activate()
        coordinateButton.addTarget(self, action: #selector(focusToMe), for: .touchUpInside)
    }

    private func setOkButton() {
        view.addSubview(okButton)
        okButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).activate()
        okButton.heightAnchor.constraint(equalToConstant: 48).activate()
        okButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 60).activate()
        okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        okButton.addTarget(self, action: #selector(closeScreenn), for: .touchUpInside)
    }

    private func setDescriptionLabel() {
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 40).activate()
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).activate()
    }

    private func setMapView() {
        view.addSubview(mapView)
        mapView.disableAutoresizingMask()
        mapView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 25).activate()
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).activate()
    }

    private func setCloseButton() {
        view.addSubview(closeButton)
        closeButton.heightAnchor.constraint(equalToConstant: 20).activate()
        closeButton.widthAnchor.constraint(equalToConstant: 20).activate()
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).activate()
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22).activate()
        closeButton.addTarget(self, action: #selector(closeScreenn), for: .touchUpInside)
    }

    private func setTitle() {
        view.addSubview(titleLable)
        titleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).activate()
        titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
    }

    private func addMarker(model: MarkersData, color: UIColor) {
        let marker = GMSMarker(position: model.coordinate)
        marker.icon = GMSMarker.markerImage(with: color)
        marker.map = mapView
        marker.title = model.title
    }

    @objc private func focusToMe() {
        let meCoordinate = CLLocationCoordinate2D(latitude: 59.207729, longitude: 39.840382)
        addMarker(model: .init(title: "me", coordinate: meCoordinate, address: ""), color: .blue)
        mapView.animate(toZoom: 18)
        mapView.animate(toLocation: meCoordinate)
    }

    @objc func closeScreenn() {
        presenter?.dismiss()
    }
}

extension MapViewController: MapViewProtocol {
    func showDetail(model: MarkersData) {
        let detailViewController = DetailMarkerViewController()
        if let sheet = detailViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
        detailViewController.setupView(model: model)
        present(detailViewController, animated: true)
    }

    func closeScreen() {
        dismiss(animated: true)
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let mark = markers.first { $0.title == marker.title }
        marker.icon = GMSMarker.markerImage(with: .blue)
        guard let mark = mark else {
            return false
        }
        presenter?.showDetailView(model: mark)
        return true
    }
}
