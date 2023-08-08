
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        
        let feedViewController = UINavigationController(rootViewController: FeedViewController())
        feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "doc.richtext"), tag: 0)
        feedViewController.view.tintColor = .black
        
        let userService: UserService
        
        let loginFactory = MyLoginFactory()
        
//        let loginInspector = LoginInspector()
        let loginInspector = loginFactory.makeLoginInspector()
        
    #if DEBUG
        let testUserService = TestUserService(testUser: testUser)
        userService = testUserService
    #else
        let currentUserService = CurrentUserService(currentUser: groot)
        userService = currentUserService
    #endif
        
        let loginViewController = LoginViewController(userService: userService, loginDelegate: loginInspector)
        
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)
        loginNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        
        
        if let loginNavigationController = loginNavigationController.viewControllers.first as? LoginViewController {
            loginNavigationController.loginDelegate = loginInspector
        }
        
        let tabBarController = UITabBarController()
        tabBarController.view.tintColor = .systemBlue
        tabBarController.viewControllers = [feedViewController, loginNavigationController]
        
        window.rootViewController = tabBarController
        
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
}

