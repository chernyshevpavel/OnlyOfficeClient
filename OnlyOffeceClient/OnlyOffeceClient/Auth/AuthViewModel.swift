//
//  AuthViewModel.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 10.04.2021.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    
    @Published var myCounter = 0
    
    public func counter() {
        self.myCounter += 1
    }
}


