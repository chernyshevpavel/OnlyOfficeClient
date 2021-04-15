//
//  String + Extension.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 15.04.2021.
//

import Foundation

extension String {
    func localized (bundle: Bundle = .main, tableName: String? = nil) -> String {
        NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
}
