//
//  DocumentsViewModel.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 14.04.2021.
//

import Foundation
import Combine

class DocumentsViewModel {
    private(set) var documentsType: DocumentsType
    
    private let requestFactory: RequestFactory
    private let errorParser: AbstractErrorParser
    private let logger: Logger
    private(set) var folderId: Int
    
    @Published private var currentlyLoading = false
    
    private var documentsCellModels: [DocumentCellModel] = []
    private var selectedRow: IndexPath?
    
    init(documentsType: DocumentsType, requestFactory: RequestFactory, errorParser: AbstractErrorParser, logger: Logger, rootFolderId: Int = 0) {
        self.documentsType = documentsType
        self.requestFactory = requestFactory
        self.errorParser = errorParser
        self.logger = logger
        self.folderId = rootFolderId
    }
}

extension DocumentsViewModel: DocumentsViewModelType {
 
    var currentlyLoadingPublisher: Published<Bool>.Publisher { $currentlyLoading }
    
    func load() {
        DispatchQueue.main.async {
            self.currentlyLoading = true
        }
        let filesRequestFactory = requestFactory.makeFilesRequestFactory(errorParser: errorParser)
        let requestType: FilesRequestType = folderId > 0 ? .folderId(folderId) : .documentsType(documentsType)
        filesRequestFactory.getFiles(filesRequestType: requestType, page: 1) { afResponse in
            switch afResponse.result {
            case .success(let baseResult):
                let filesResponse = baseResult.response
                var documentsCellModels: [DocumentCellModel] = []
                let dateFormater = DateFormatter()
                dateFormater.dateStyle = .medium
                dateFormater.timeStyle = .none
                for folder in filesResponse.folders {
                    documentsCellModels.append(DocumentCellModel(
                                                id: folder.id,
                                                name: folder.title,
                                                createDate: dateFormater.string(from: folder.created),
                                                type: .folder,
                                                fileExt: nil))
                }
                for file in filesResponse.files {
                    documentsCellModels.append(DocumentCellModel(
                                                id: file.id,
                                                name: file.title,
                                                createDate: dateFormater.string(from: file.created),
                                                type: .document,
                                                fileExt: file.fileExst))
                }
                DispatchQueue.main.async {
                    self.documentsCellModels = documentsCellModels
                    self.currentlyLoading = false
                }
                
            case .failure(let error):
                self.logger.error(error)
                DispatchQueue.main.async {
                    self.currentlyLoading = false
                }
            }
        }
    }
    
    func numberOfRows() -> Int {
        self.documentsCellModels.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DocumentCellViewModelType? {
        guard indexPath.row < documentsCellModels.count else {
            return nil
        }
        let cellModel = documentsCellModels[indexPath.row]
        return DocumentCellViewModel(model: cellModel)
    }
    
    func viewModelForSelectedRow() -> DocumentsViewModelType? {
        guard let selectedRow = selectedRow, selectedRow.row < documentsCellModels.count else {
            return nil
        }
        let cellModel = documentsCellModels[selectedRow.row]
        guard cellModel.type == .folder else {
            return nil
        }
        return DocumentsViewModel(documentsType: self.documentsType,
                                  requestFactory: requestFactory,
                                  errorParser: errorParser,
                                  logger: logger,
                                  rootFolderId: cellModel.id)
    }
    
    func selectedRow(forIdexPath indexPath: IndexPath) {
        self.selectedRow = indexPath
    }
}
