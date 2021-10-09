//
//  Extension + UITextField.swift
//  Test2
//
//  Created by Рамил Гаджиев on 07.10.2021.
//

import UIKit


extension UITextField {
    
    convenience init (placeholder: String = "", isPassword: Bool = false) {
        self.init()
        self.placeholder = placeholder
        font = UIFont(name: "KohinoorBangla-Regular", size: 14)
        backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        clearButtonMode = .whileEditing
        borderStyle = .bezel
        layer.masksToBounds = true
        
        if isPassword {
            isSecureTextEntry = true
        }
        
        
    }
    
    func fillTextField(placeholder: String) {
        backgroundColor = #colorLiteral(red: 0.9238616824, green: 0.643689096, blue: 0.689083159, alpha: 1)
        self.placeholder = "Заполните данное поле"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            self.placeholder = placeholder
        }
    }
    
    
}
