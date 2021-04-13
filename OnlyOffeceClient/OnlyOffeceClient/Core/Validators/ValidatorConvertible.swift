//
//  File.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}
