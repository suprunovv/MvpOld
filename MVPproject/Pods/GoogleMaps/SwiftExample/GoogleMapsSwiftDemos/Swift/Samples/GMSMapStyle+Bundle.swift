// GMSMapStyle+Bundle.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps

extension GMSMapStyle {
    convenience init?(named fileName: String) throws {
        guard let styleURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        try self.init(contentsOfFileURL: styleURL)
    }
}
