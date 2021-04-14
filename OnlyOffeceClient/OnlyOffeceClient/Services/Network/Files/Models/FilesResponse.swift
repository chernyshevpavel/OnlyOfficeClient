//
//  FilesResponse.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 14.04.2021.
//

import Foundation

struct FilesResponse: Codable {
    let files: [PortalFile]
    let folders: [PortalFolder]
    let current: PortalFolder
    let pathParts: [Int]
    let startIndex, count, total: Int
}
