//
//  DocumentsViewModelType.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 14.04.2021.
//

import Foundation

typealias Filename = String

protocol DocumentsViewModelType {
    var documentsType: DocumentsType { get }
    var folderId: Int { get }

    var currentlyLoadingPublisher: Published<Bool>.Publisher { get }
    
    func load()
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DocumentCellViewModelType?
    func viewModelForSelectedRow() -> DocumentsViewModelType?
    func storeDocumentForSelectedRow(competion: @escaping (URL?, ErrorMessage?) -> Void)
    func selectedRow(forIdexPath indexPath: IndexPath)
}
