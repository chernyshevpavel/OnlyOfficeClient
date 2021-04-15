//
//  ErrorStatusParser.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation

class ErrorStatusParser: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        result
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        if let response = response {
            if response.statusCode >= 400 {
                return StatusError(statusCode: response.statusCode,
                                   description: "\(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
            }
        }
        return error
    }
}
