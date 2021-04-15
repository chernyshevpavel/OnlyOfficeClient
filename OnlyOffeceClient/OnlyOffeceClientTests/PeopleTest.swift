//
//  PeopleTest.swift
//  OnlyOffeceClientTests
//
//  Created by Павел Чернышев on 13.04.2021.
//

import XCTest
import Alamofire
@testable import OnlyOffeceClient

class PeopleTest: XCTestCase {
    
    var authHelper: AuthHelper?

    override func setUpWithError() throws {
        authHelper = AuthHelper()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        authHelper = nil
        try super.tearDownWithError()
    }

    func testPeopleSelf() throws {
        guard let authHelper = authHelper else {
            XCTFail("Couldn't get auth helper")
            return
        }
        let requestFactory = authHelper.auth()
        let peopleRequestFactrory = requestFactory.makePeopleRequestFactory(errorParser: ErrorParser())
        
        let expect = expectation(description: "person self")
        peopleRequestFactrory.getSelf { response in
            switch response.result {
            case .success(let baseResponse):
                XCTAssertFalse(baseResponse.response.userName.isEmpty)
                guard let avatarPath = URL(string: baseResponse.response.avatar) else {
                    XCTFail("Couldn't cats \(baseResponse.response.avatar) to URL")
                    return
                }
                requestFactory.makeDataRequestFactory(errorParser: ErrorParser()).get(url: avatarPath) { afResponse in
                    switch afResponse.result {
                    case .success(let imageData):
                        guard let data = imageData else {
                            XCTFail("image data not found")
                            return
                        }
                        guard UIImage(data: data) != nil else {
                            XCTFail("Couldn't get image from data")
                            return
                        }
                        expect.fulfill()
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 10)
    }

}
