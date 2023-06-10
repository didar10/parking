//
//  SceneDelegate.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 05.06.2023.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupAppScreen(scene: scene)
    }
    
    func setupAppScreen(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let user = Auth.auth().currentUser
        if user == nil {
            let viewController = LoginVC()
            let navigationController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        } else {
            let viewController = TabBarViewController()
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
    }
}

