//
//  StatusError.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation

struct StatusError: Error, ErrorDescriber {
    var statusCode: Int
    var description: String
    
    func getErrorDescription() -> String? {
        return "Error code: \(statusCode) - \(description)"
    }
}
