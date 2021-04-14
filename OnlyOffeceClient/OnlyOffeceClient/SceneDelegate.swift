//
//  SceneDelegate.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 08.04.2021.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var container: Container?
    var configurator: ContainerConfigurator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        container = Container()
        guard let container = container else {
            fatalError("unimpossible error")
        }
        
        configurator = ContainerConfigurator()
        guard let configurator = configurator else {
            fatalError("unimpossible error")
        }
        
        configurator.configure(container)
        
        window?.rootViewController = container.resolve(AuthViewController.self)
        
        
//        let documents = DocumentsViewController()
//        documents.title = "My Documents"
//        let myDocuments = UINavigationController(rootViewController: documents)
//        //myDocuments.title = "My"
//        myDocuments.tabBarItem = UITabBarItem(title: "My documents", image: UIImage(systemName: "folder.badge.person.crop"), tag: 0)
//        myDocuments.tabBarItem.selectedImage = UIImage(systemName: "folder.badge.person.crop.fill")
//
//        let commonDocuments = UINavigationController(rootViewController: DocumentsViewController())
//        commonDocuments.tabBarItem = UITabBarItem(title: "Common documents", image: UIImage(systemName: "folder.badge.gear"), tag: 1)
//        commonDocuments.tabBarItem.selectedImage = UIImage(systemName: "folder.fill.badge.gear")
//
//        let profileViewController = UINavigationController(rootViewController: container.resolve(ProfileViewController.self)!)
//        let personalTabbarItem = UITabBarItem(title: "Common documents", image: UIImage(systemName: "person"), tag: 2)
//        personalTabbarItem.selectedImage = UIImage(systemName: "person.fill")
//        profileViewController.tabBarItem = personalTabbarItem
//
//        let mainTabbarController = UITabBarController()
//        mainTabbarController.setViewControllers([
//            myDocuments,
//            commonDocuments,
//            profileViewController
//        ], animated: false)
        
        //window?.rootViewController =  container.resolve(MainTabbarController.self)!
       // window?.rootViewController =  container.resolve(MainTabbarController.self)!
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

