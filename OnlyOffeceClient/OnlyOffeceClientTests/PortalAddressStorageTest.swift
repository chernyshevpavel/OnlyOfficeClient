//
//  PortalAddressStorageTest.swift
//  OnlyOffeceClientTests
//
//  Created by Павел Чернышев on 12.04.2021.
//

import XCTest
import Alamofire
@testable import OnlyOffeceClient

class PortalAddressStorageTest: XCTestCase {

    func testSuccess() throws {
        let storage = PortalAddressStorageUserDafaults()
        storage.delete()
        XCTAssertNil(storage.get())
        guard let myUrl = URL(string: "https://mytest.com") else {
            XCTFail()
            return
        }
        storage.save(portalAddress: myUrl)
        XCTAssertEqual(storage.get(), myUrl)
    }

    func testFailure() throws {
        let storage = PortalAddressStorageUserDafaults()
        guard let myUrl = URL(string: "https://mytest.com") else {
            XCTFail()
            return
        }
        storage.save(portalAddress: myUrl)
        guard let mySecondUrl = URL(string: "https://mytest2.com") else {
            XCTFail()
            return
        }
        XCTAssertNotEqual(storage.get(), mySecondUrl)
    }

}
