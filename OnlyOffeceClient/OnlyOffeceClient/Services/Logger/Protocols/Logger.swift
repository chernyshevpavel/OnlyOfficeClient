//
//  Logger.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import Foundation

protocol Logger {
    func error(_ error: Error)
    func log(_ message: String) 
}
