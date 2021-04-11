//
//  BaseError.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation

struct BaseError: Codable {
    let message: String
    let hresult: Int
    let data: EmptyStruct
    
    struct EmptyStruct: Codable {
        
    }
}
