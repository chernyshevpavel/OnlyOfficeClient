//
//  TokenStorageUserDefaults.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation

class TokenStorageUserDefaults: TokenStorage {
    
    private let userTokenKey = "userToken"
    private let userTokenExpiresIn = "userTokenExpiresIn"
    
    func save(token: TokenStorageModel) {
        let defaults = UserDefaults.standard
        defaults.setValue(token.token, forKey: userTokenKey)
        defaults.setValue(String(token.expiresIn), forKey: userTokenExpiresIn)
    }
    
    func delete() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: userTokenKey)
        defaults.removeObject(forKey: userTokenExpiresIn)
    }
    
    func get() -> TokenStorageModel? {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: userTokenKey),
              let expires = TimeInterval(defaults.string(forKey: userTokenExpiresIn) ?? "") else {
            return nil
        }
        return TokenStorageModel(token: token, expiresIn: expires)
    }
}
