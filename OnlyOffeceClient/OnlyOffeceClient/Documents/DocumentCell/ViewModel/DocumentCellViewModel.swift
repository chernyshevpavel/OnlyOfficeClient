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
    
    private(set) var title: String
    
    private(set) var date: String
    
    private(set) var accessoryType: UITableViewCell.AccessoryType
    
    init(model: DocumentCellModel) {
        title = model.name
        date = model.createDate
        switch model.type {
        case .folder:
            accessoryType = .disclosureIndicator
            image = UIImage(systemName: "folder.fill")?.withRenderingMode(.alwaysTemplate)
            imageColor = .systemYellow
        case .document:
            accessoryType = .none
            image = UIImage(systemName: "doc.text.fill")
            guard let ext = model.fileExt else {
                return
            }
            switch ext {
            case ".docx", ".doc":
                imageColor = .systemBlue
            case ".pptx":
                imageColor = .systemOrange
            case ".xlsx", ".csv", "xls":
                imageColor = .systemGreen
            default:
                imageColor = .systemFill
            }
        }
        
    }
}
