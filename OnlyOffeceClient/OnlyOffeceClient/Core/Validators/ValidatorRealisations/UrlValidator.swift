//
//  UrlValidator.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation
import UIKit

struct UrlValidator: ValidatorConvertible {
    
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            throw ValidationError(NSLocalizedString("Url can not be empty", comment: ""))
        }
        
        guard let url = NSURL(string: value) else {
            throw ValidationError(NSLocalizedString("Invalid url", comment: ""))
        }
        
        guard url.isFileURL || (url.host != nil && url.scheme != nil) else {
            if !(url.host != nil && url.scheme != nil) {
                throw ValidationError(NSLocalizedString("Invalid url: host or schame is absent", comment: ""))
            }
            throw ValidationError(NSLocalizedString("Invalid url", comment: ""))
        }
        return value
    }
}
