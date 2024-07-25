// SceneDelegate.swift

import Swinject
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setupWindow(withScene: scene)
    }

    private func setupWindow(withScene scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator()
        appCoordinator?.start()
    }

    static func setContainer() -> Container {
        let container = Container()
        container.register(LoadImageService.self) { _ in LoadImageService() }.inObjectScope(.container)
        container.register(NetworkService.self) { _ in NetworkService() }.inObjectScope(.container)
        container.register(LoadImageProxy.self) { result in
            LoadImageProxy(service: result.resolve(LoadImageService.self))
        }.inObjectScope(.container)
        return container
    }

    // suprunovRecipesApp://openScreen?screen=favorites
    // suprunovRecipesApp://change?name=Anton

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first,
              let firstUrlComponents = URLComponents(url: firstUrl.url, resolvingAgainstBaseURL: true) else { return }

        switch firstUrlComponents.host {
        case "openScreen":
            openScreen(items: firstUrlComponents.queryItems ?? [])
        case "change":
            change(items: firstUrlComponents.queryItems ?? [])
        default:
            break
        }
    }

    private func openScreen(items: [URLQueryItem]) {
        let screenQuery = items.first { $0.name == "screen" }

        switch screenQuery?.value {
        case "profile":
            appCoordinator?.toScreen(.profile)
        case "favorites":
            appCoordinator?.toScreen(.favorites)
        case "recipes":
            appCoordinator?.toScreen(.recipes)
        default:
            break
        }
    }

    private func change(items: [URLQueryItem]) {
        let changeQuery = items.first { $0.name == "name" }
        let newName = changeQuery?.value ?? "default"
        appCoordinator?.changeUserName(to: newName)
    }
}
