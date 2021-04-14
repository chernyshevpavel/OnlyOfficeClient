//
//  AuthViewModel.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 10.04.2021.
//

import Foundation
import Combine

class AuthViewModel: AuthViewModelType {
    
    let portalAddressStorage: PortalAdressStorage
    let tokenStorage: TokenStorage
    let errorParser: AbstractErrorParser
    
    private var requestFactory: RequestFactory?
    
    init(portalAddressStorage: PortalAdressStorage, tokenStorage: TokenStorage, errorParser: AbstractErrorParser) {
        self.portalAddressStorage = portalAddressStorage
        self.tokenStorage = tokenStorage
        self.errorParser = errorParser
    }
    
    func login(portal: String, email: String, password: String, complition: @escaping (Success, ErrorMessage?) -> Void) {
        guard let portalUrl = URL(string: portal) else {
            complition(false, "Couldn't cas \(portal) to url")
            return
        }
        portalAddressStorage.save(portalAddress: portalUrl)
        let requestFactory = RequestFactory(portalAdressStorage: portalAddressStorage, tokenStorage: tokenStorage)
        self.requestFactory = requestFactory
        let authFactory = requestFactory.makeAuthRequestFactory(errorParser: self.errorParser)
        authFactory.getToken(email: email, password: password) { response in
            switch response.result {
            case .success(let tokenResponse):
                guard let expiresTimestamp = self.convertDate(tokenResponse.response.expires) else {
                    complition(false, "\(NSLocalizedString("Couldn't cast expires to timestamp", comment: "")): \(tokenResponse.response.expires)")
                    return
                }
                let tokenStorageModel = TokenStorageModel(token: tokenResponse.response.token, expiresIn: expiresTimestamp)
                self.tokenStorage.save(token: tokenStorageModel)
                complition(true, nil)
            case .failure(let error):
                var errorMessage = ""
                if let parsedError = error.underlyingError as? ErrorDescriber {
                    errorMessage = parsedError.getErrorDescription() ?? error.localizedDescription
                } else {
                    errorMessage = error.localizedDescription
                }
                complition(false, errorMessage)
            }
        }
    }
    
    private func convertDate(_ date: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS+hh:mm") -> TimeInterval? {
        let formater = DateFormatter()
        formater.dateFormat = format
        guard let date = formater.date(from: date) else {
            return nil
        }
        return date.timeIntervalSince1970
    }
}


