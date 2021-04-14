//
//  Person.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation

struct Person: Codable {
    let id, userName: String
    let isVisitor: Bool
    let firstName, lastName, email: String
    let status, activationStatus: Int
    let terminated: String?
    let department, workFrom, displayName, mobilePhone: String
    let avatarMedium, avatar: String
    let isAdmin, isLDAP: Bool
    let listAdminModules: [String]
    let isOwner, isSSO: Bool
    let avatarSmall: String
    let profileUrl: String
}
