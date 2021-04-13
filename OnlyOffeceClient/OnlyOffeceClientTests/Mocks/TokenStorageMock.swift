//
//  PortalAddresStorageMock.swift
//  OnlyOffeceClientTests
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation
@testable import OnlyOffeceClient

class TokenStorageMock: TokenStorage {
    
    var token: TokenStorageModel?
    
    func save(token: TokenStorageModel) {
        self.token = token
    }
    
    func delete() {
        token = nil
    }
    
    func get() -> TokenStorageModel? {
        return token
    }
}
