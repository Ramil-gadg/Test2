//
//  Extension + UIStackView.swift
//  Test2
//
//  Created by Рамил Гаджиев on 07.10.2021.
//

import UIKit

extension UIStackView {
    convenience init (firstView: UIView, secondView: UIView, axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat) {
        self.init(arrangedSubviews: [firstView, secondView])
        self.spacing = spacing
        self.axis = axis
    }
}
