// GradientPolylinesViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

struct Coordinate: Decodable {
    let latitude: Double
    let longitude: Double
    let elevation: Double

    enum CodingKeys: String, CodingKey {
        case elevation
        case latitude = "lat"
        case longitude = "lng"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        elevation = try container.decode(Double.self, forKey: .elevation)
    }
}

final class GradientPolylinesViewController: UIViewController {
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(
            latitude: 44.1314, longitude: 9.6921, zoom: 14.059, bearing: 328, viewingAngle: 40
        )
        return GMSMapView(frame: .zero, camera: camera)
    }()

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTrackToMap()
    }

    private func addTrackToMap() {
        guard let filePath = Bundle.main.path(forResource: "track", ofType: "json") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return }
        guard let track = try? JSONDecoder().decode([Coordinate].self, from: data)
        else {
            return
        }
        let path = GMSMutablePath()
        var colorSpans: [GMSStyleSpan] = []
        var previousColor: UIColor?

        for coordinate in track {
            path.addLatitude(coordinate.latitude, longitude: coordinate.longitude)

            let elevation = CGFloat(coordinate.elevation)
            let toColor = UIColor(hue: elevation / 700.0, saturation: 1, brightness: 0.9, alpha: 1)
            let fromColor = previousColor ?? toColor
            let style = GMSStrokeStyle.gradient(from: fromColor, to: toColor)
            colorSpans.append(GMSStyleSpan(style: style))
            previousColor = toColor
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 6
        polyline.map = mapView
        polyline.spans = colorSpans
    }
}
