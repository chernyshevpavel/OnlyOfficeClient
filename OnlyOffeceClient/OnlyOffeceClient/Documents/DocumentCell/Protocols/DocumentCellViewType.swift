//
//  DocumentCellViewType.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import UIKit

protocol DocumentCellViewType: UITableViewCell {
    var viewModel: DocumentCellViewModelType? { get set }
}
