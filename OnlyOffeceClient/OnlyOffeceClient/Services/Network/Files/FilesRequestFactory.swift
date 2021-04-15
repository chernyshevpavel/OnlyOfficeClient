//
//  FilesRequestFactory.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 14.04.2021.
//

import Foundation
import Alamofire

class FilesRequestFactory: AbstractRequestFactory {
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

extension FilesRequestFactory: FilesRequestFactoryProtocol {
    func getFiles(
        filesRequestType: FilesRequestType,
        page: Int,
        completionHandler: @escaping (AFDataResponse<BaseResponse<FilesResponse>>) -> Void
    ) {
        let requestModel = FilesRequestRouter(filesRequestType: filesRequestType, page: page, baseUrl: baseUrl)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension FilesRequestFactory {
    struct FilesRequestRouter: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String
        let page: Int
        var parameters: Parameters?
        
        init(filesRequestType: FilesRequestType, page: Int, baseUrl: URL) {
            self.page = page
            self.baseUrl = baseUrl
            switch filesRequestType {
            case .documentsType(let type):
                self.path = "files/\(type.rawValue)"
            case .folderId(let id):
                self.path = "files/\(id)"
            }
            print(path)
        }
    }
}
