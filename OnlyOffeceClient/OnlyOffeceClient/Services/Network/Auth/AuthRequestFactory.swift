//
//  AuthRequestFactory.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation
import Alamofire

class AuthRequestFactory: AbstractRequestFactory {
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    let baseUrl: URL

    init(
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility),
        baseUrl: URL
    ) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
        self.baseUrl = baseUrl
    }
}

extension AuthRequestFactory: AuthRequestFactoryProtocol {
    func getToken(email userName: String, password: String, completionHandler: @escaping (AFDataResponse<AuthenticationResponse>) -> Void) {
        let requestModel = AuthRequestRouter(baseUrl: baseUrl, userName: userName, password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension AuthRequestFactory {
    struct AuthRequestRouter: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "authentication"

        let userName: String
        let password: String
        var parameters: Parameters? {
            [
                "userName": userName,
                "password": password
            ]
        }
    }
}
