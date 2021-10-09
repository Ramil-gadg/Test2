//
//  Extension + UILabel.swift
//  Test2
//
//  Created by Рамил Гаджиев on 07.10.2021.
//

import UIKit

extension UILabel {
    
    convenience init (text: String) {
        self.init()
        self.text = text
        self.font = UIFont(name: "KohinoorBangla-Regular", size: 16)
        self.textColor = .black
        numberOfLines = 0
    }
}
