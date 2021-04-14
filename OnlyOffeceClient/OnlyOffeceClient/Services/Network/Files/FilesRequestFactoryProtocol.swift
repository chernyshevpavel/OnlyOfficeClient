//
//  FilesRequestFactoryProtocol.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 14.04.2021.
//

import Foundation
import Alamofire

enum DocumentsType: String {
    case my = "@my"
    case common = "@common"
}

enum FilesRequestType {
    case documentsType(DocumentsType)
    case folderId(Int)
}

protocol FilesRequestFactoryProtocol {
    func getFiles(filesRequestType: FilesRequestType,
                  page: Int,
                  completionHandler: @escaping (AFDataResponse<BaseResponse<FilesResponse>>) -> Void)
}
