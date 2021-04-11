//
//  AuthRequestFactoryProtocol.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation
import Alamofire

protocol AuthRequestFactoryProtocol {
    func getToken(email: String, password: String, completionHandler: @escaping (AFDataResponse<AuthenticationResponse>) -> Void)
}
