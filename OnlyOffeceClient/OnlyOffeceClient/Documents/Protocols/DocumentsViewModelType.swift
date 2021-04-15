//
//  DocumentsViewModelType.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 14.04.2021.
//

import Foundation

protocol DocumentsViewModelType {
    var documentsType: DocumentsType { get }
    var folderId: Int { get }

    var currentlyLoadingPublisher: Published<Bool>.Publisher { get }
    
    func load()
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DocumentCellViewModelType?
    func viewModelForSelectedRow() -> DocumentsViewModelType?
    func selectedRow(forIdexPath indexPath: IndexPath)
}
