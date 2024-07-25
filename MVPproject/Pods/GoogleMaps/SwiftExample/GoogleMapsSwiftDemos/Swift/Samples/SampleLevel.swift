// SampleLevel.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps

enum SampleLevel: Equatable {
    case fakeGroundLevel
    case actualLevel(GMSIndoorLevel)

    init(indoorLevel: GMSIndoorLevel?) {
        if let level = indoorLevel {
            self = .actualLevel(level)
        } else {
            self = .fakeGroundLevel
        }
    }

    var name: String {
        switch self {
        case .fakeGroundLevel:
            return "\u{2014}" // use an em dash for 'above ground'
        case let .actualLevel(level):
            return level.name ?? ""
        }
    }

    var shortName: String? {
        switch self {
        case .fakeGroundLevel:
            return nil
        case let .actualLevel(level):
            return level.shortName ?? ""
        }
    }

    var indoorLevel: GMSIndoorLevel? {
        switch self {
        case .fakeGroundLevel:
            return nil
        case let .actualLevel(level):
            return level
        }
    }
}
