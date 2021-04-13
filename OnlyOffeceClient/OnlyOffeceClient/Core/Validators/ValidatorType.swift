//
//  ValidatorType.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation

enum ValidatorType {
    case url
    case email
    case requiredField(field: String)
}
