// Samples.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

struct Sample {
    let viewControllerClass: UIViewController.Type
    let title: String
}

struct Section {
    let name: String
    let samples: [Sample]
}

enum Samples {
    static func allSamples() -> [Section] {
        let mapSamples = [
            Sample(viewControllerClass: BasicMapViewController.self, title: "Basic Map"),
            Sample(viewControllerClass: MapTypesViewController.self, title: "Map Types"),
            Sample(viewControllerClass: StyledMapViewController.self, title: "Styled Map"),
            Sample(viewControllerClass: TrafficMapViewController.self, title: "Traffic Layer"),
            Sample(viewControllerClass: MyLocationViewController.self, title: "My Location"),
            Sample(viewControllerClass: IndoorViewController.self, title: "Indoor"),
            Sample(
                viewControllerClass: CustomIndoorViewController.self,
                title: "Indoor with Custom Level Select"
            ),
            Sample(
                viewControllerClass: IndoorMuseumNavigationViewController.self,
                title: "Indoor Museum Navigator"
            ),
            Sample(viewControllerClass: GestureControlViewController.self, title: "Gesture Control"),
            Sample(viewControllerClass: SnapshotReadyViewController.self, title: "Snapshot Ready"),
            Sample(viewControllerClass: DoubleMapViewController.self, title: "Two Maps"),
            Sample(viewControllerClass: VisibleRegionViewController.self, title: "Visible Regions"),
            Sample(viewControllerClass: MapZoomViewController.self, title: "Min/Max Zoom"),
            Sample(viewControllerClass: FrameRateViewController.self, title: "Frame Rate"),
            Sample(viewControllerClass: PaddingBehaviorViewController.self, title: "Padding Behavior"),
        ]
        let overlaySamples = [
            Sample(viewControllerClass: MarkersViewController.self, title: "Markers"),
            Sample(viewControllerClass: CustomMarkersViewController.self, title: "Custom Markers"),
            Sample(viewControllerClass: AnimatedUIViewMarkerViewController.self, title: "UIView Markers"),
            Sample(viewControllerClass: MarkerEventsViewController.self, title: "Marker Events"),
            Sample(viewControllerClass: MarkerLayerViewController.self, title: "Marker Layer"),
            Sample(
                viewControllerClass: MarkerInfoWindowViewController.self, title: "Custom Info Windows"
            ),
            Sample(viewControllerClass: PolygonsViewController.self, title: "Polygons"),
            Sample(viewControllerClass: PolylinesViewController.self, title: "Polylines"),
            Sample(viewControllerClass: GroundOverlayViewController.self, title: "Ground Overlays"),
            Sample(viewControllerClass: TileLayerViewController.self, title: "Tile Layers"),
            Sample(
                viewControllerClass: AnimatedCurrentLocationViewController.self,
                title: "Animated Current Location"
            ),
            Sample(
                viewControllerClass: GradientPolylinesViewController.self, title: "Gradient Polylines"
            ),
        ]
        let panoramaSamples = [
            Sample(viewControllerClass: PanoramaServiceController.self, title: "Panorama Service"),
            Sample(viewControllerClass: PanoramaViewController.self, title: "Street View"),
            Sample(viewControllerClass: FixedPanoramaViewController.self, title: "Fixed Street View"),
        ]
        let cameraSamples = [
            Sample(viewControllerClass: FitBoundsViewController.self, title: "Fit Bounds"),
            Sample(viewControllerClass: CameraViewController.self, title: "Camera Animation"),
            Sample(viewControllerClass: MapLayerViewController.self, title: "Map Layer"),
        ]
        let serviceSamples = [
            Sample(viewControllerClass: GeocoderViewController.self, title: "Geocoder"),
            Sample(
                viewControllerClass: StructuredGeocoderViewController.self, title: "Structured Geocoder"
            ),
        ]
        return [
            Section(name: "Map", samples: mapSamples),
            Section(name: "Panorama", samples: panoramaSamples),
            Section(name: "Overlays", samples: overlaySamples),
            Section(name: "Camera", samples: cameraSamples),
            Section(name: "Services", samples: serviceSamples),
        ]
    }
}
