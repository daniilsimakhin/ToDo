//
//  SceneDelegate.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let itemList = ItemListViewController()
        
        let navViewController = UINavigationController()
        navViewController.viewControllers = [itemList]
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navViewController
        window?.makeKeyAndVisible()  
    }
}
