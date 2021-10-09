//
//  UserModel.swift
//  Test2
//
//  Created by Рамил Гаджиев on 07.10.2021.
//

import Foundation


struct UserModel: Codable {
    var id: String?
    var lastname: String?
    var firstname: String?
    var fathername: String?
    var birth_place: String?
    var birthdate: String?
    var organization: String?
    var position: String?
    var preferences: [String]?
    var email: String?
    var password: String?
    
}
