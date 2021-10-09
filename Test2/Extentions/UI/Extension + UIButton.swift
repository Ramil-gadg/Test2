//
//  Extension + UIButton.swift
//  Test2
//
//  Created by Рамил Гаджиев on 07.10.2021.
//

import UIKit


extension UIButton {
    
    convenience init(title: String, hasBackgroundColor: Bool ) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: "KohinoorBangla-Regular", size: 16)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.5
        if hasBackgroundColor {
            layer.cornerRadius = 10
            backgroundColor = #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1)
            setTitleColor(.white, for: .normal)
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 4
        } else {
            backgroundColor = .clear
            setTitleColor(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), for: .normal)
        }
        
        
        
        
       
        
    }
}
