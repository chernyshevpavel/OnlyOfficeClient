//
//  ContainerConfigurator.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation
import Swinject

class ContainerConfigurator {
    func configure(_ container: Container) {
        storageServicesRegister(container)
        networkServicesRegister(container)
        errorParsersRegister(container)
        authViewControllerRegister(container)
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
                          requestFactory: RequestFactory(portalAdressStorage: r.resolve(PortalAdressStorage.self)!, tokenStorage: r.resolve(TokenStorage.self)!),
                          errorParser: r.resolve(AbstractErrorParser.self)!)
        }
        
        container.register(AuthViewController.self) { r in
            AuthViewController(viewModel: r.resolve(AuthViewModelType.self)!, succesAuthViewController: UIViewController())
        }
    }
    
}
