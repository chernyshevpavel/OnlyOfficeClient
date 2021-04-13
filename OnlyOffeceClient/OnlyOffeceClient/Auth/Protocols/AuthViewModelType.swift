//
//  AuthViewModelType.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation

typealias Success = Bool
typealias ErrorMessage = String

protocol AuthViewModelType {
    func login(portal: String, email: String, password: String, complition: @escaping (Success, ErrorMessage?) -> Void)
}
