//
//  TokenStorage.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation

protocol TokenStorage {
    func save(token: TokenStorageModel)
    func delete() 
    func get() -> TokenStorageModel?
}
