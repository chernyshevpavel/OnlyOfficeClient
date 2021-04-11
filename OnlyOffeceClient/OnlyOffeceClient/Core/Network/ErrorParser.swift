//
//  ErrorParser.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation

class ErrorParser: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        result
    }

    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        error
    }
}
