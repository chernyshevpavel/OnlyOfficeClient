//
//  ValidationError.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation

class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}
