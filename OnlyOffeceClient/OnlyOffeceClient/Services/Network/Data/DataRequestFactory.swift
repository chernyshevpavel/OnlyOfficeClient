//
//  DataRequestFactory.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation
import Alamofire

class DataRequestFactory: AbstractRequestFactory {
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

extension DataRequestFactory: DataRequestFactoryProtocol {
    func get(url: URL, completionHandler: @escaping (AFDataResponse<Data?>) -> Void) {
        var baseUrl: URL = self.baseUrl
        var path = ""
        if url.host != nil {
            baseUrl = url
        } else {
            path = url.absoluteString
        }
        
        let requestModel = DataRequestRouter(baseUrl: baseUrl, path: path)
        AF.request(requestModel).response { response in
            completionHandler(response)
        }
    }
}

extension DataRequestFactory {
    struct DataRequestRouter: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String
        var parameters: Parameters?
        var encoding: RequestRouterEncoding = .withoutEncoding
    }
}
