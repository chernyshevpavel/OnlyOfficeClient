//
//  AbstractRequestFactory.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation
import Alamofire

protocol AbstractRequestFactory {
    var errorParser: AbstractErrorParser { get }
    var sessionManager: Session { get }
    var queue: DispatchQueue { get }

    @discardableResult
    func request<T: Decodable>(
        request: URLRequestConvertible,
        completionHandler: @escaping (AFDataResponse<T>) -> Void
    ) -> DataRequest
}

extension AbstractRequestFactory {

    @discardableResult
    public func request<T: Decodable>(
        request: URLRequestConvertible,
        completionHandler: @escaping (AFDataResponse<T>) -> Void
    ) -> DataRequest {
        sessionManager
                .request(request)
                .responseCodable(errorParser: errorParser, queue: queue, completionHandler: completionHandler)
    }
}
