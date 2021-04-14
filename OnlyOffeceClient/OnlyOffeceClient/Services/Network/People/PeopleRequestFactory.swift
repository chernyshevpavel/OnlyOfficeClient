//
//  PeopleRequestFactory.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation
import Alamofire

class PeopleRequestFactory: AbstractRequestFactory {
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

extension PeopleRequestFactory: PeopleRequestFactoryProtocol {
    func getSelf(completionHandler: @escaping (AFDataResponse<BaseResponse<Person>>) -> Void) {
        let requestModel = PeopleSelfRequestRouter(baseUrl: baseUrl)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension PeopleRequestFactory {
    struct PeopleSelfRequestRouter: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "people/@self"
        var parameters: Parameters?
    }
}
