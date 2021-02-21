import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let tabBarController = UITabBarController()
        
        let heroesItem = UITabBarItem()
        heroesItem.title = "Heroes"
        heroesItem.image = UIImage(systemName: "house")
        
        let heroesFavoriteItem = UITabBarItem()
        heroesFavoriteItem.title = "Favorites"
        heroesFavoriteItem.image = UIImage(systemName: "star.fill")
        
        let heroesViewController = HeroesFactory.make()
        heroesViewController.tabBarItem = heroesItem
        
        let heroesFavoritesViewController = HeroesFavoritesFactory.make()
        heroesFavoritesViewController.tabBarItem = heroesFavoriteItem
        
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: heroesViewController),
            UINavigationController(rootViewController: heroesFavoritesViewController)
        ]
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
