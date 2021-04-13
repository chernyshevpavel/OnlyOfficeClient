//
//  PortalAddressStorageUserDafaults.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation

class PortalAddressStorageUserDafaults: PortalAdressStorage {

    private let portalAddressKey = "portalAddress"
    
    func save(portalAddress address: URL) {
        let defaults = UserDefaults.standard
        defaults.setValue(address.absoluteString, forKey: portalAddressKey)
    }
    
    
    func delete() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: portalAddressKey)
    }
    
    func get() -> URL? {
        let defaults = UserDefaults.standard
        guard let portalAddress = defaults.string(forKey: portalAddressKey),
              let portalAddressUrl = URL(string: portalAddress) else {
            return nil
        }
        return portalAddressUrl
    }
}
