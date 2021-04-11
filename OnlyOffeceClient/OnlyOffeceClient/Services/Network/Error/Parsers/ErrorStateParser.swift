//
//  ErrorStateParser.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation

class ErrorParserState<T: Decodable & ErrorDescriber & Error>: AbstractErrorParser {
    
    func parse(_ result: Error) -> Error {
        result
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        guard let data = data, error == nil else {
            
            return error
        }
        do {
            let parsedError = try JSONDecoder().decode(T.self, from: data)
            return parsedError
        } catch {
            return nil
        }
    }
}
