//
//  FilesAtedBy.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 14.04.2021.
//

import Foundation

struct FilesAtedBy: Codable {
    let id, displayName, avatarSmall: String
    let profileURL: String

    enum CodingKeys: String, CodingKey {
        case id, displayName, avatarSmall
        case profileURL = "profileUrl"
    }
}
