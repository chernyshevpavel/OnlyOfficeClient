//
//  FilesTest.swift
//  OnlyOffeceClientTests
//
//  Created by Павел Чернышев on 14.04.2021.
//

import XCTest
import Alamofire
@testable import OnlyOffeceClient

class FilesTest: XCTestCase {
    var authHelper: AuthHelper?

    override func setUpWithError() throws {
        authHelper = AuthHelper()
    }

    override func tearDownWithError() throws {
        authHelper = nil
    }

    func testMyFiles() throws {
        filesBy(fileseRequestType: .documentsType(.my))
    }
    
    func testCommonFiles() throws {
        filesBy(fileseRequestType: .documentsType(.common))
    }
    
    private func filesBy(fileseRequestType requestType: FilesRequestType) {
        guard let authHelper = authHelper else {
            XCTFail()
            return
        }
        let expect = expectation(description: "files")
        let requestFactory = authHelper.auth()
        let parser = ErrorParsersChain(errorParsers: [ErrorParserState<BaseErrorResponse>(), ErrorStatusParser()])
        let filesRequestFactrory = requestFactory.makeFilesRequestFactory(errorParser: parser)
        filesRequestFactrory.getFiles(filesRequestType: requestType, page: 1) { afResponse in
            switch afResponse.result {
            case .success(let baseResult):
                let filesResponse = baseResult.response
                XCTAssertGreaterThan(filesResponse.count, 1)
                XCTAssertGreaterThan(filesResponse.files.count, 0)
                XCTAssertGreaterThan(filesResponse.folders.count, 0)
                guard let firstFile = filesResponse.files.first else {
                    XCTFail()
                    return
                }
                XCTAssertFalse(firstFile.title.isEmpty)
                guard let folderFile = filesResponse.folders.first else {
                    XCTFail()
                    return
                }
                XCTAssertFalse(folderFile.title.isEmpty)
                self.innerFolders(experct: expect, requestFactory: requestFactory, folderId: folderFile.id)
            case .failure(let error):
                if let parsedError = error as? ErrorDescriber {
                    XCTFail(parsedError.getErrorDescription() ?? error.localizedDescription)
                }
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 3)
    }

    func innerFolders(experct: XCTestExpectation, requestFactory: RequestFactory, folderId: Int) {
        let parser = ErrorParsersChain(errorParsers: [ErrorParserState<BaseErrorResponse>(), ErrorStatusParser()])
        let filesRequestFactrory = requestFactory.makeFilesRequestFactory(errorParser: parser)
        filesRequestFactrory.getFiles(filesRequestType: .folderId(folderId), page: 1) { afResponse in
            switch afResponse.result {
            case .success(let baseResult):
                let filesResponse = baseResult.response
                XCTAssertGreaterThan(filesResponse.count, 0)
                XCTAssertGreaterThan(filesResponse.files.count, 0)
                guard let firstFile = filesResponse.files.first else {
                    XCTFail()
                    return
                }
                XCTAssertFalse(firstFile.title.isEmpty)
                experct.fulfill()
            case .failure(let error):
                if let parsedError = error.underlyingError as? ErrorDescriber {
                    XCTFail(parsedError.getErrorDescription() ?? error.localizedDescription)
                }
                XCTFail(error.localizedDescription)
            }
        }
    }
}
