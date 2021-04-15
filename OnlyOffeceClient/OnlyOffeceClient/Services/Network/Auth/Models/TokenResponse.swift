//
//  TokenResponse.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation

struct TokenResponse: Codable {
    let token: String
    let expires: Date
}
