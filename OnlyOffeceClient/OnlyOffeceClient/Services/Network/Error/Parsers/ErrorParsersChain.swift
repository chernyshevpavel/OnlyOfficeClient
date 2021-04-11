//
//  ErrorParsersChain.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation

class ErrorParsersChain: AbstractErrorParser {
    
    var errorParsers: [AbstractErrorParser]
    var parsedError: Error?
    
    init(errorParsers: [AbstractErrorParser]) {
        self.errorParsers = errorParsers
    }
    
    func parse(_ result: Error) -> Error {
        result
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        for parser in errorParsers {
            if let parsedError = parser.parse(response: response, data: data, error: error) {
                self.parsedError = parsedError
                return parsedError
            }
        }
        return error
    }
}
