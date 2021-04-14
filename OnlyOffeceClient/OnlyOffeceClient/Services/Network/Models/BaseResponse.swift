//
//  BaseResponse.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let count: Int
    let status: Int
    let statusCode: Int
    let response: T
}
