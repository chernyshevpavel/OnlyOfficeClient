//
//  DocumentTableViewCell.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import UIKit

class DocumentTableViewCell: UITableViewCell, DocumentCellViewType {
    var viewModel: DocumentCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {
                return
            }
            self.imageView?.image = viewModel.image
            self.imageView?.tintColor = viewModel.imageColor
            self.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            self.textLabel?.text = viewModel.name
            self.detailTextLabel?.text = viewModel.date
            self.accessoryType = viewModel.accessoryType
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }

}
