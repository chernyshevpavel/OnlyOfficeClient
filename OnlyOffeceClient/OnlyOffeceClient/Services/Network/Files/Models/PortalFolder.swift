//
//  PortalFolder.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 14.04.2021.
//

import Foundation

struct PortalFolder: Codable {
    let parentID, filesCount, foldersCount: Int
    let isShareable: Bool?
    let id: Int
    let title: String
    let access: Int
    let shared: Bool
    let rootFolderType: Int
    let updatedBy: FilesAtedBy
    let created: String
    let createdBy: FilesAtedBy
    let updated: String

    enum CodingKeys: String, CodingKey {
        case parentID = "parentId"
        case filesCount, foldersCount, isShareable, id, title, access, shared, rootFolderType, updatedBy, created, createdBy, updated
    }
}
