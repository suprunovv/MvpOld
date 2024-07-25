// MarkersData.swift
// Copyright © RoadMap. All rights reserved.

import CoreLocation
import Foundation

/// Модель для маркера
struct MarkersData {
    let title: String
    let coordinate: CLLocationCoordinate2D
    let address: String

    static func getAllMarcers() -> [MarkersData] {
        [
            .init(
                title: "Magaz norm",
                coordinate: .init(latitude: 59.220869, longitude: 39.896859),
                address: "Lenina 8"
            ),
            .init(
                title: "Magaz u doma",
                coordinate: .init(latitude: 59.210304, longitude: 39.880716),
                address: "Mira 122"
            ),
            .init(
                title: "Dengi228",
                coordinate: .init(latitude: 59.213183, longitude: 39.898530),
                address: "Zosimovskaya 39"
            ),
            .init(
                title: "Eda Eda",
                coordinate: .init(latitude: 59.225267, longitude: 39.889160),
                address: "Naberejnaya 15"
            ),
            .init(
                title: "Shaurma 24/7",
                coordinate: .init(latitude: 59.227781, longitude: 39.875164),
                address: "Burmagin 7"
            ),
            .init(
                title: "Lavka RoadMap",
                coordinate: .init(latitude: 59.208853, longitude: 39.877814),
                address: "Cherneshevskaya 23"
            ),
            .init(
                title: "PutinShop",
                coordinate: .init(latitude: 59.214311, longitude: 39.854243),
                address: "Samera 99"
            )
        ]
    }
}
