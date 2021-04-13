//
//  PortalAdressStorage.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 12.04.2021.
//

import Foundation

protocol PortalAdressStorage {
    func save(portalAddress address: URL)
    func delete()
    func get() -> URL?
}
