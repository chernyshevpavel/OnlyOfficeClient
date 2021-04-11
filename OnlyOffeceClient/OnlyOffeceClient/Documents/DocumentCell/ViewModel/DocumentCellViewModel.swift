//
//  DocumentCellViewModel.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import UIKit

class DocumentCellViewModel: DocumentCellViewModelType {
    
    private(set) var image: UIImage?
    
    private(set) var imageColor: UIColor = .systemFill
    
    private(set) var name: String
    
    private(set) var date: String
    
    private(set) var accessoryType: UITableViewCell.AccessoryType
    
    init(model: DocumentCellModel) {
        name = model.name
        date = model.createDate
        switch model.type {
        case .Folder:
            accessoryType = .disclosureIndicator
            image = UIImage(systemName: "folder.fill")?.withRenderingMode(.alwaysTemplate)
            imageColor = .systemYellow
        case .Document:
            accessoryType = .none
            image = UIImage(systemName: "doc.text.fill")
            // MARK: TODO image color depends on document exe
        }
        
    }
}
