//
//  SceneDelegate.swift
//  ESP32
//
//  Created by Max on 04.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Создаем окно
        let window = UIWindow(windowScene: windowScene)

        // Указываем начальный ViewController

        window.rootViewController = UINavigationController(rootViewController: InitialViewController())

        // Делаем окно видимым
        self.window = window
        window.makeKeyAndVisible()
    }
}
