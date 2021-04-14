//
//  ProfileViewModel.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation
import Alamofire
import Swinject
import Combine

class ProfileViewModel: ProfileViewModelType {
    
    @Published var profile: ProfileModel
    var profilePublisher: Published<ProfileModel>.Publisher { $profile }

    let requestFactory: RequestFactory
    let portalAddressStorage: PortalAdressStorage
    let tokenStorage: TokenStorage
    let logger: Logger
    var subscr: AnyCancellable?
    weak var container: Container?
    weak var containerConfigurator: ContainerConfigurator?
    
    init(requestFactory: RequestFactory, portalAddressStorage: PortalAdressStorage, tokenStorage: TokenStorage, logger: Logger) {
        self.requestFactory = requestFactory
        self.portalAddressStorage = portalAddressStorage
        self.tokenStorage = tokenStorage
        self.logger = logger
        self.profile = ProfileModel()
    }
    
    func loadProfile() {
        let peopleRequestFacctory = requestFactory.makePeopleRequestFactory(errorParser: ErrorParser())
        peopleRequestFacctory.getSelf { response in
            switch response.result {
            case .success(let base):
                var profile = self.profile
                profile.fullName = "\(base.response.firstName) \(base.response.lastName)"
                profile.email = base.response.email
                guard let imageUrl = URL(string: base.response.avatar) else {
                    return
                }
               
                self.requestFactory.makeDataRequestFactory(errorParser: ErrorParser()).get(url: imageUrl) { response in
                    switch response.result {
                    
                    case .success(let data):
                        guard let imageData = data else {
                            DispatchQueue.main.async {
                                self.profile = profile
                            }
                            self.logger.log("Couldn't get date")
                            return
                        }
                        guard let image = UIImage(data: imageData, scale: 1) else {
                            DispatchQueue.main.async {
                                self.profile = profile
                            }
                            self.logger.log("Couldn't load image by data")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            profile.image = image
                            self.profile = profile
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.profile = profile
                        }
                        self.logger.error(error)
                    }
                }
            case .failure(let error):
                self.logger.error(error)
            }
        }
    }
    
    func logout(completion: @escaping (UIViewController?) -> Void) {
        portalAddressStorage.delete()
        tokenStorage.delete()
        guard let container = container else {
            fatalError()
        }
        container.removeAll()
        guard let containerConfigurator = containerConfigurator else {
            fatalError()
        }
        containerConfigurator.configure(container)
        
        DispatchQueue.main.async {
            let viewController = container.resolve(AuthViewController.self)
            completion(viewController)
        }
        
    }
}
