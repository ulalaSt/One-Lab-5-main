//
//  SceneDelegate.swift
//  One-Lab-5
//
//  Created by Farukh on 23.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let newsMainPage = NewsMainPage(viewModel: NewsViewModel(newsService: NewsServiceImpl()))
        window?.rootViewController = UINavigationController(rootViewController: newsMainPage)
        window?.makeKeyAndVisible()
    }
}

