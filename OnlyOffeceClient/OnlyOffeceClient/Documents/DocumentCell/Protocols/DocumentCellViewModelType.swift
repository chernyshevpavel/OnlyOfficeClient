//
//  DetailCellVMType.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 11.04.2021.
//

import UIKit

protocol DocumentCellViewModelType {
    var image: UIImage? { get }
    var imageColor: UIColor { get }
    var title: String { get }
    var date: String { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
}
