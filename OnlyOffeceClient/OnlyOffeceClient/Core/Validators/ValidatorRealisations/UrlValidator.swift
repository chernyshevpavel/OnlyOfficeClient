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
            throw ValidationError("Url can not be empty".localized())
        }
        
        guard let url = NSURL(string: value) else {
            throw ValidationError("Invalid url".localized())
        }
        
        guard url.isFileURL || (url.host != nil && url.scheme != nil) else {
            if !(url.host != nil && url.scheme != nil) {
                throw ValidationError("Invalid url: host or schame is absent".localized())
            }
            throw ValidationError("Invalid url".localized())
        }
        return value
    }
}
