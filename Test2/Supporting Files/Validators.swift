//
//  Validators.swift
//  Test2
//
//  Created by Рамил Гаджиев on 08.10.2021.
//

import Foundation


class Validators{
    
    static func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    static func isSimilarPasswords (password: String, repeatPassword: String) -> Bool {
        if password == repeatPassword {
            return true
        } else {
            return false
        }
    }
}
