//
//  UnitTestsHelper.swift
//  OnlyOffeceClientTests
//
//  Created by Павел Чернышев on 11.04.2021.
//


import Foundation
import Alamofire
@testable import OnlyOffeceClient

class AuthHelper {
    
    let requestFactory: RequestFactory
    var portalAddressStorage: PortalAdressStorage = PortalAddresStorageMock(url: "https://pavelchernyshev.onlyoffice.eu")
    var tokenStorage: TokenStorage = TokenStorageUserDefaults()
    
    init() {
        requestFactory = RequestFactory(portalAdressStorage: portalAddressStorage, tokenStorage: tokenStorage)
    }
    
    func auth() -> RequestFactory {
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "userName") ?? ""
        let password = defaults.string(forKey: "password") ?? ""
        let errorParser = ErrorParserState<BaseErrorResponse>()
        let auth = requestFactory.makeAuthRequestFactory(errorParser: errorParser)
        
        let semaphore = DispatchSemaphore(value: 0)
        auth.getToken(email: userName, password: password) { response in
            switch response.result {
            case .success(let getTokenResult):
                self.tokenStorage.save(token: TokenStorageModel(token: getTokenResult.response.token, expiresIn: 100000000000))
                semaphore.signal()
            case .failure(let error):
                if let parsedError = error.underlyingError as? BaseErrorResponse {
                    fatalError(parsedError.getErrorDescription() ?? error.localizedDescription)
                }
                fatalError(error.localizedDescription)
            }
        }
        semaphore.wait()
        return RequestFactory(portalAdressStorage: portalAddressStorage, tokenStorage: tokenStorage)
    }

}
