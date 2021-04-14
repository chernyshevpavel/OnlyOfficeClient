//
//  NothingLogger.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation

class NothingLogger: Logger {
    func error(_ error: Error) {
        print(error.localizedDescription)
    }
    
    func log(_ message: String) {
        print(message)
    }
}
