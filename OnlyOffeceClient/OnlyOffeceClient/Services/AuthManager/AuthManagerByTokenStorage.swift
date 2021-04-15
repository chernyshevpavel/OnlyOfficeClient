//
//  AuthManagerByTokenStorage.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 15.04.2021.
//

import Foundation

class AuthManagerByTokenStorage: AuthManager {

    private let tokenStorage: TokenStorage
    
    init(tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }
    
    func isAuthorized() -> Bool {
        guard let token = tokenStorage.get() else {
            return false
        }
        
        guard token.expiresIn > NSDate().timeIntervalSince1970 else {
            return false
        }
        
        // MARK: - TODO make shure the token valid and exist on portal
        return true
    }
    
    
}
