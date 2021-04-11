//
//  RequestFactory.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation
import Alamofire

class RequestFactory {

    let baseUrl: URL
    private let token: String

    lazy var commonSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        configuration.headers.add(HTTPHeader(name: "Authorization", value: token))
        let manager = Session(configuration: configuration)
        return manager
    }()
    
    var sessionQueue = DispatchQueue.global(qos: .utility)

    init(baseUrlStr: String, token: String = "") {
        guard var baseUrl = URL(string: baseUrlStr) else {
            fatalError("Couldn't cast string \(baseUrlStr) to URL")
        }
        baseUrl.appendPathComponent("/api/2.0")
        self.baseUrl = baseUrl
        self.token = token
    }

//    func setToken(token: Token) {
//        let sessionConfiguration = commonSession.sessionConfiguration
//        sessionConfiguration.headers.add(
//            name: "Authorization",
//            value: "\(token.tokenType) \(token.accessToken)")
//        self.commonSession = Session(configuration: sessionConfiguration)
//    }

    func makeAuthRequestFactory(errorParser: AbstractErrorParser) -> AuthRequestFactoryProtocol {
        AuthRequestFactory(errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue, baseUrl: baseUrl)
    }
}
