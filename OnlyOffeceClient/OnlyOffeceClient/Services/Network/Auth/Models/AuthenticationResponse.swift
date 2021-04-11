//
//  AuthenticationResponse.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation

struct AuthenticationResponse: Codable {
    let count: Int
    let status: Int
    let statusCode: Int
    let response: Response
    
    struct Response: Codable {
        let token: String
        let expires: String
    }
}
