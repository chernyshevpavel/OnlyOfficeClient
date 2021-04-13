//
//  TokenStorageTest.swift
//  OnlyOffeceClientTests
//
//  Created by Павел Чернышев on 12.04.2021.
//

import XCTest
import Alamofire
@testable import OnlyOffeceClient

class TokenStorageTest: XCTestCase {
    func testSuccess() throws {
        let storage = TokenStorageUserDefaults()
        storage.delete()
        XCTAssertNil(storage.get())
        let token = TokenStorageModel(token: "mytesttoken", expiresIn: 123)
        storage.save(token: token)
        let gettedToken = storage.get()
        XCTAssertEqual(gettedToken?.token, token.token)
        XCTAssertEqual(gettedToken?.expiresIn, token.expiresIn)
    }

    func testFailure() throws {
        let storage = TokenStorageUserDefaults()
        storage.delete()
        XCTAssertNil(storage.get())
        let token = TokenStorageModel(token: "mytesttoken", expiresIn: 123)
        storage.save(token: token)
        let gettedToken = storage.get()
        XCTAssertNotEqual(gettedToken?.token, "\(token.token)_")
        XCTAssertNotEqual(gettedToken?.expiresIn, token.expiresIn + 1)
    }}
