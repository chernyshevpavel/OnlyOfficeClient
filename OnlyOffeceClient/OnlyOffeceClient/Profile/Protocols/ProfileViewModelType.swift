//
//  ProfileViewModelType.swift
//  OnlyOffeceClient
//
//  Created by Павел Чернышев on 13.04.2021.
//

import UIKit

protocol ProfileViewModelType {
    
    var profilePublisher: Published<ProfileModel>.Publisher { get }
    
    func loadProfile() -> Void
    func logout(completion: @escaping (UIViewController?) -> Void)
}
