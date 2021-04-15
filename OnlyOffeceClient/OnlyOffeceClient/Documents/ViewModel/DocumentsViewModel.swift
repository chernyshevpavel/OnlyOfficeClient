//
//  DocumentsViewModel.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 14.04.2021.
//

import Foundation
import Combine

class DocumentsViewModel {
    var documentsType: DocumentsType
    var folderId: Int = 0
    var errorParser: AbstractErrorParser
    var logger: Logger
    
    var documentsCellModels: [DocumentCellModel] = []
    
    @Published private var currentlyLoading = false
    
    var requestFactory: RequestFactory
    
    init(documentsType: DocumentsType, requestFactory: RequestFactory, errorParser: AbstractErrorParser, logger: Logger) {
        self.documentsType = documentsType
        self.requestFactory = requestFactory
        self.errorParser = errorParser
        self.logger = logger
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
                for folder in filesResponse.folders {
                    documentsCellModels.append(DocumentCellModel(
                                                name: folder.title,
                                                createDate: folder.created,
                                                type: .folder,
                                                fileExt: nil))
                }
                for file in filesResponse.files {
                    documentsCellModels.append(DocumentCellModel(
                                                name: file.title,
                                                createDate: file.created,
                                                type: .focument,
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
        nil
    }
    
    func selectedRow(forIdexPath indexPath: IndexPath) {
        
    }
}
