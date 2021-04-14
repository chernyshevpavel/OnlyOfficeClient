//
//  PeopleRequestFactoryProtocol.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation

import Alamofire

protocol PeopleRequestFactoryProtocol {
    func getSelf(completionHandler: @escaping (AFDataResponse<BaseResponse<Person>>) -> Void)
}
