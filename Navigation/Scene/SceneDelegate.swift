
import UIKit
import FirebaseCore
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appConfiguration: AppConfiguration?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        FirebaseApp.configure()
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        appConfiguration = [.people, .planets, .starships].randomElement()

        if let configuration = appConfiguration {
            NetworkService.request(for: configuration)
        }

        let mainCoordinator = MainCoordinator.shared
        let rootViewController = mainCoordinator.startApp()
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        CheckerService.shared.signOut { result in
            switch result {
            case(.success()):
                print("✅ LogOut is successful")
            case(.failure(let error)):
                print("❌", error.errorDescription)
            }
        }
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

