//
//  ValidatorFactory.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .url: return UrlValidator()
        case .email: return EmailValidator()
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        }
    }
}
