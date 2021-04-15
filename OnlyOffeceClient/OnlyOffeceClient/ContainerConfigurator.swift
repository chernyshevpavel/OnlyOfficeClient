//
//  ContainerConfigurator.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation
import Swinject

typealias MainTabbarController = UITabBarController
typealias MyDocumentsViewController = DocumentsViewController
typealias CommonDocumentsViewController = DocumentsViewController

typealias MyDocumentsTabbarItem = UITabBarItem
typealias CommonDocumentsTabbarItem = UITabBarItem
typealias ProfileTabbarItem = UITabBarItem

class ContainerConfigurator {
    func configure(_ container: Container) {
        storageServicesRegister(container)
        networkServicesRegister(container)
        errorParsersRegister(container)
        loggerServicesRegister(container)
        authManagerServiceRegister(container)
        
        authViewControllerRegister(container)
        myDocumentsViewController(container)
        commonDocumentsViewController(container)
        profileViewControllerRegister(container)
        
        myDocumentsTabbarItemRegister(container)
        commonDocumentsTabbarItemRegister(container)
        profileTabbarItemRegister(container)
        
        mainTabbarControllerRegister(container)
    }
    
    // MARK: - Services
    private func storageServicesRegister(_ container: Container) {
        container.register(PortalAdressStorage.self) { _ in
            PortalAddressStorageUserDafaults()
        }
        container.register(TokenStorage.self) { _ in
            TokenStorageUserDefaults()
        }
    }
    
    private func networkServicesRegister(_ container: Container) {
        container.register(RequestFactory.self) { r in
            RequestFactory(portalAdressStorage: r.resolve(PortalAdressStorage.self)!, tokenStorage: r.resolve(TokenStorage.self)!)
        }
    }
    
    private func loggerServicesRegister(_ container: Container) {
        container.register(Logger.self) { _ in
            NothingLogger()
        }
    }
    
    private func authManagerServiceRegister(_ container: Container) {
        container.register(AuthManager.self) { r in
            AuthManagerByTokenStorage(tokenStorage: r.resolve(TokenStorage.self)!)
        }
    }
    
    // MARK: - Error parsers
    private func errorParsersRegister(_ container: Container) {
        
        container.register(AbstractErrorParser.self) { _ in
            ErrorParsersChain(errorParsers: [ErrorParserState<BaseErrorResponse>(), ErrorParserState()])
        }
    }
    
    // MARK: - Screens
    private func authViewControllerRegister(_ container: Container) {
        container.register(AuthViewModelType.self) { r in
            AuthViewModel(portalAddressStorage: r.resolve(PortalAdressStorage.self)!,
                          tokenStorage: r.resolve(TokenStorage.self)!,
                          errorParser: r.resolve(AbstractErrorParser.self)!)
        }
        
        container.register(AuthViewController.self) { r in
            AuthViewController(viewModel: r.resolve(AuthViewModelType.self)!)
        }.initCompleted { (r, authVC) in
            authVC.succesAuthViewController = r.resolve(MainTabbarController.self)!
        }
    }
    
    private func myDocumentsViewController(_ container: Container) {
        container.register(MyDocumentsViewController.self, name: "my") { r in
            let viewController = DocumentsViewController(viewModel: DocumentsViewModel(documentsType: .my,
                                                                                       requestFactory: r.resolve(RequestFactory.self)!,
                                                                                       errorParser: r.resolve(AbstractErrorParser.self)!,
                                                                                       logger: r.resolve(Logger.self)!),
                                                         requestFactory: r.resolve(RequestFactory.self)!)
            viewController.title = NSLocalizedString("My Documents", comment: "")
            return viewController
        }
    }
    
    private func commonDocumentsViewController(_ container: Container) {
        container.register(CommonDocumentsViewController.self, name: "common") { r in
            let viewController = DocumentsViewController(viewModel: DocumentsViewModel(documentsType: .common,
                                                                                       requestFactory: r.resolve(RequestFactory.self)!,
                                                                                       errorParser: r.resolve(AbstractErrorParser.self)!,
                                                                                       logger: r.resolve(Logger.self)!),
                                                         requestFactory: r.resolve(RequestFactory.self)!)
            viewController.title = NSLocalizedString("Common Documents", comment: "")
            return viewController
        }
    }
    
    private func profileViewControllerRegister(_ container: Container) {
        container.register(ProfileViewModelType.self) { r in
            let viewModel = ProfileViewModel(requestFactory: r.resolve(RequestFactory.self)!,
                                             portalAddressStorage: r.resolve(PortalAdressStorage.self)!,
                                             tokenStorage: r.resolve(TokenStorage.self)!,
                                             logger: r.resolve(Logger.self)!)
            viewModel.container = container
            viewModel.containerConfigurator = self
            return viewModel
        }
        
        container.register(ProfileViewController.self) { r in
            ProfileViewController(viewModel: r.resolve(ProfileViewModelType.self)!)
        }
    }
    
    // MARK: - Tabbar items
    private func myDocumentsTabbarItemRegister(_ container: Container) {
        container.register(MyDocumentsTabbarItem.self, name: "my") { _ in
            let tabBarItem = UITabBarItem(title: NSLocalizedString("My documents", comment: ""), image: UIImage(systemName: "folder.badge.person.crop"), tag: 0)
            tabBarItem.selectedImage = UIImage(systemName: "folder.badge.person.crop.fill")
            return tabBarItem
        }
    }
    
    private func commonDocumentsTabbarItemRegister(_ container: Container) {
        container.register(CommonDocumentsTabbarItem.self, name: "common") { _ in
            let tabBarItem = UITabBarItem(title: NSLocalizedString("Common documents", comment: ""), image: UIImage(systemName: "folder.badge.gear"), tag: 1)
            tabBarItem.selectedImage = UIImage(systemName: "folder.fill.badge.gear")
            return tabBarItem
        }
    }
    
    private func profileTabbarItemRegister(_ container: Container) {
        container.register(ProfileTabbarItem.self, name: "profile") { _ in
            let tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person"), tag: 2)
            tabBarItem.selectedImage = UIImage(systemName: "person.fill")
            return tabBarItem
        }
    }
    
    // MARK: - Tabbars
    private func mainTabbarControllerRegister(_ container: Container) {
        container.register(MainTabbarController.self) { r in
            let myDocumentsNavigationController = UINavigationController(
                rootViewController: r.resolve(MyDocumentsViewController.self, name: "my")!)
            myDocumentsNavigationController.tabBarItem = r.resolve(MyDocumentsTabbarItem.self, name: "my")!
            
            let commonDocumentsNavigationController = UINavigationController(
                rootViewController: r.resolve(CommonDocumentsViewController.self, name: "common")!)
            commonDocumentsNavigationController.tabBarItem = r.resolve(CommonDocumentsTabbarItem.self, name: "common")!
            
            let profileNavigationController = UINavigationController(rootViewController: r.resolve(ProfileViewController.self)!)
            profileNavigationController.tabBarItem = r.resolve(ProfileTabbarItem.self, name: "profile")!
            
            let mainTabbarController = UITabBarController()
            mainTabbarController.setViewControllers([
                myDocumentsNavigationController,
                commonDocumentsNavigationController,
                profileNavigationController
            ], animated: false)
            return mainTabbarController
        }
    }
}
