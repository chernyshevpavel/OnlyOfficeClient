//
//  DocumentCellModel.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation

enum DocumentType {
    case Folder
    case Document
}

struct DocumentCellModel {
    var name: String
    var createDate: String
    var type: DocumentType
}