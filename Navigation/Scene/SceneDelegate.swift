
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appConfiguration: AppConfiguration?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        appConfiguration = [.people, .planets, .starships].randomElement()

        if let configuration = appConfiguration {
            NetworkService.request(for: configuration)
        }

        let mainCoordinator = MainCoordinator()
        let rootViewController = mainCoordinator.startApp()
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

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

