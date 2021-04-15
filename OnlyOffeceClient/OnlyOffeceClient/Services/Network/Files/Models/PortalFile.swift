//
//  PortalFile.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 14.04.2021.
//

import Foundation

struct PortalFile: Codable {
    let folderID, version, versionGroup: Int
    let contentLength: String
    let pureContentLength, fileStatus: Int
    let viewURL: String
    let webURL: String
    let fileType: Int
    let fileExst: String
    let comment: String?
    let id: Int
    let title: String
    let access: Int
    let shared: Bool
    let rootFolderType: Int
    let updatedBy: FilesAtedBy
    let created: Date
    let createdBy: FilesAtedBy
    let updated: Date

    enum CodingKeys: String, CodingKey {
        case folderID = "folderId"
        case version, versionGroup, contentLength, pureContentLength, fileStatus
        case viewURL = "viewUrl"
        case webURL = "webUrl"
        case fileType, fileExst, comment, id, title, access, shared, rootFolderType, updatedBy, created, createdBy, updated
    }
}
