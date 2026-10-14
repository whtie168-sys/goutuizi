import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController(rootViewController: ErrandListViewController())
        nav.navigationBar.prefersLargeTitles = true
        window.rootViewController = nav
        window.tintColor = .systemOrange
        window.makeKeyAndVisible()
        self.window = window
    }
}
