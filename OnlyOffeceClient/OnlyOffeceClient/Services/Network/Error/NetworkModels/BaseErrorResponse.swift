//
//  BaseErrorResponse.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation

struct BaseErrorResponse: Codable, Error, ErrorDescriber {
    
    let status, statusCode: Int
    let error: BaseError

    func getErrorDescription() -> String? {
        error.message
    }
}
