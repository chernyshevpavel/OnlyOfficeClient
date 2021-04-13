//
//  PortalAddresStorageMock.swift
//  OnlyOffeceClientTests
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation
@testable import OnlyOffeceClient

class PortalAddresStorageMock: PortalAdressStorage {
    var url: URL?
    
    init(url: String) {
        guard let url = URL(string: url) else {
            self.url = nil
            return
        }
        self.url = url
    }
    
    
    func save(portalAddress address: URL) {
        self.url = address
    }
    
    func delete() {
        url = nil
    }
    
    func get() -> URL? {
        return url
    }
}
