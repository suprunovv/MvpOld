// AppDelegate.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey(SDKConstants.apiKey)
        // Metal is the preferred renderer.
        GMSServices.setMetalRendererEnabled(true)

        // On iOS 15, continue to use opaque navigation bars like earlier iOS versions.
        if #available(iOS 15.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }

        let sampleListViewController = SampleListViewController()
        let frame = UIScreen.main.bounds
        let window = UIWindow(frame: frame)
        let navigationController = UINavigationController(rootViewController: sampleListViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
