//
//  DataRequestFactoryProtocol.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation
import Alamofire

protocol DataRequestFactoryProtocol {
    func get(url: URL, completionHandler: @escaping (AFDataResponse<Data?>) -> Void)
}
