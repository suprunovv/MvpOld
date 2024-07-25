// SampleMapStyle.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps

enum SampleMapStyle: CustomStringConvertible, CaseIterable {
    case normal
    case retro
    case grayscale
    case night
    case clean

    private static let mapStyleJSON = """
    [
      {
        "featureType" : "poi.business",
        "elementType" : "all",
        "stylers" : [
          {
            "visibility" : "off"
          }
        ]
      },
      {
        "featureType" : "transit",
        "elementType" : "labels.icon",
        "stylers" : [
          {
            "visibility" : "off"
          }
        ]
      }
    ]
    """

    var description: String {
        switch self {
        case .normal:
            return "Normal"
        case .retro:
            return "Retro"
        case .grayscale:
            return "Grayscale"
        case .night:
            return "Night"
        case .clean:
            return "No business points of interest, no transit"
        }
    }

    var mapStyle: GMSMapStyle? {
        switch self {
        case .normal:
            return nil
        case .retro:
            return try? GMSMapStyle(named: "mapstyle-retro")
        case .grayscale:
            return try? GMSMapStyle(named: "mapstyle-silver")
        case .night:
            return try? GMSMapStyle(named: "mapstyle-night")
        case .clean:
            return try? GMSMapStyle(jsonString: SampleMapStyle.mapStyleJSON)
        }
    }
}
