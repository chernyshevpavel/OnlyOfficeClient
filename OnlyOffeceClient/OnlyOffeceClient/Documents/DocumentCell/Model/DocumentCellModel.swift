//
//  DocumentCellModel.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import Foundation

enum DocumentType {
    case folder
    case document
}

struct DocumentCellModel {
    var id: Int
    var name: String
    var link: String?
    var createDate: String
    var type: DocumentType
    var fileExt: String?
}
