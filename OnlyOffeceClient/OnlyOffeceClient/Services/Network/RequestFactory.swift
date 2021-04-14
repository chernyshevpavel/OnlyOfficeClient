//
//  RequestFactory.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation
import Alamofire

class RequestFactory {
    
    private let portalAdressStorage: PortalAdressStorage
    private let tokenStorage: TokenStorage
    
    lazy var baseUrl: URL = {
        guard var baseUrl = portalAdressStorage.get() else {
            fatalError("Couldn't find portal address")
        }
        baseUrl.appendPathComponent("/api/2.0")
        return baseUrl
    }()

    lazy var commonSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        if let tokenModel = tokenStorage.get() {
            configuration.headers.add(HTTPHeader(name: "Authorization", value: tokenModel.token))
        }
        let manager = Session(configuration: configuration)
        return manager
    }()
    
    var sessionQueue = DispatchQueue.global(qos: .utility)

    init(portalAdressStorage: PortalAdressStorage, tokenStorage: TokenStorage) {
        self.portalAdressStorage = portalAdressStorage
        self.tokenStorage = tokenStorage
    }

    func makeAuthRequestFactory(errorParser: AbstractErrorParser) -> AuthRequestFactoryProtocol {
        AuthRequestFactory(errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue, baseUrl: baseUrl)
    }
    
    func makePeopleRequestFactory(errorParser: AbstractErrorParser) -> PeopleRequestFactoryProtocol {
        PeopleRequestFactory(errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue, baseUrl: baseUrl)
    }
    
    func makeFilesRequestFactory(errorParser: AbstractErrorParser) -> FilesRequestFactoryProtocol {
        FilesRequestFactory(errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue, baseUrl: baseUrl)
    }
    
    func makeDataRequestFactory(errorParser: AbstractErrorParser) -> DataRequestFactoryProtocol {
        guard let portalAdress = portalAdressStorage.get() else {
            fatalError("Portal addres is missing")
        }
        return DataRequestFactory(errorParser: errorParser, sessionManager: commonSession, baseUrl: portalAdress)
    }
}
