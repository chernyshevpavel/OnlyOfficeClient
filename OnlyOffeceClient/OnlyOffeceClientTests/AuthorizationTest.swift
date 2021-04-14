//
//  AuthorizationTest.swift
//  OnlyOffeceClientTests
//
//  Created by Павел Чернышев on 11.04.2021.
//

import XCTest
import Alamofire
@testable import OnlyOffeceClient

class AuthorizationTest: XCTestCase {
    
    var userName = ""
    var password = ""
    var portalAddressStorage: PortalAdressStorage = PortalAddresStorageMock(url: "https://pavelchernyshev.onlyoffice.eu")
    var tokenStorage: TokenStorage = TokenStorageMock()
    
    
    override func setUpWithError() throws {
        let defaults = UserDefaults.standard
        // MARK: - fill it for run tests
        // set your userName for tests defaults.set("", forKey: "userName")
        // set your userName for tests defaults.set("", forKey: "password")
        userName = defaults.string(forKey: "userName") ?? ""
        password = defaults.string(forKey: "password") ?? ""
    }
    
    override func tearDownWithError() throws {
        userName = ""
        password = ""
    }
    
    func testGetToken() throws {
        let requestFactory = RequestFactory(portalAdressStorage: portalAddressStorage, tokenStorage: tokenStorage)
        let expect = expectation(description: "Get token")
        let errorParser = ErrorParserState<BaseErrorResponse>()
        let auth = requestFactory.makeAuthRequestFactory(errorParser: errorParser)
        auth.getToken(email: userName, password: password) { response in
            switch response.result {
            case .success(let getTokenResult):
                XCTAssertEqual(getTokenResult.status, 0)
                XCTAssertEqual(getTokenResult.count, 1)
                XCTAssertEqual(getTokenResult.statusCode, 201)
                XCTAssertFalse(getTokenResult.response.token.isEmpty)
                expect.fulfill()
            case .failure(let error):
                if let parsedError = error.underlyingError as? BaseErrorResponse {
                    XCTFail(parsedError.getErrorDescription() ?? "")
                }
                XCTFail(error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    
    func testGetTokenFailPasswordExpect() throws {
        let requestFactory = RequestFactory(portalAdressStorage: portalAddressStorage, tokenStorage: tokenStorage)
        let expect = expectation(description: "Get token")
        let errorParser = ErrorParserState<BaseErrorResponse>()
        let auth = requestFactory.makeAuthRequestFactory(errorParser: errorParser)
        auth.getToken(email: userName, password: "ihihih") { response in
            switch response.result {
            case .success:
                XCTFail("Expected auth error")
            case .failure(let error):
                if let parsedError = error.underlyingError as? BaseErrorResponse {
                    XCTAssertFalse(parsedError.error.message.isEmpty)
                    expect.fulfill()
                } else {
                    XCTFail(error.localizedDescription)
                }
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    func testGetTokenFailLoginExpect() throws {
        let requestFactory = RequestFactory(portalAdressStorage: portalAddressStorage, tokenStorage: tokenStorage)
        let expect = expectation(description: "Get token")
        let errorParser = ErrorParserState<BaseErrorResponse>()
        let auth = requestFactory.makeAuthRequestFactory(errorParser: errorParser)
        auth.getToken(email: "wronglogin", password: password) { response in
            switch response.result {
            case .success:
                XCTFail("Expected auth error")
            case .failure(let error):
                if let parsedError = error.underlyingError as? BaseErrorResponse {
                    XCTAssertFalse(parsedError.error.message.isEmpty)
                    expect.fulfill()
                } else {
                    XCTFail(error.localizedDescription)
                }
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    func testGetTokenFailUrlExpect() throws {
        let portalAddressStorage = PortalAddresStorageMock(url: "https://fail.onlyoffice.eu")
        let requestFactory = RequestFactory(portalAdressStorage: portalAddressStorage, tokenStorage: tokenStorage)
        let expect = expectation(description: "Get token")
        let parser = ErrorParsersChain(errorParsers: [ErrorParserState<BaseErrorResponse>(), ErrorStatusParser()])
        let auth = requestFactory.makeAuthRequestFactory(errorParser: parser)
        auth.getToken(email: userName, password: password) { response in
            switch response.result {
            case .success:
                XCTFail("Expected auth error")
            case .failure(let error):
                if let _ = error.underlyingError as? BaseErrorResponse {
                    XCTFail("Expected statusError")
                } else if let parsedError = error.underlyingError as? StatusError {
                    XCTAssertEqual(parsedError.statusCode, 404)
                    XCTAssertEqual(parsedError.getErrorDescription(), "Error code: 404 - not found")
                    expect.fulfill()
                } else {
                    XCTFail(error.localizedDescription)
                }
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    func testAuthHelper() throws {
        let authHelper = AuthHelper()
        let reuquestFactory = authHelper.auth()
        guard let token = reuquestFactory.commonSession.sessionConfiguration.headers.value(for: "Authorization") else {
            XCTFail()
            return
        }
        XCTAssertFalse(token.isEmpty)
    }
}
