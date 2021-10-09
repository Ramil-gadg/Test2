//
//  Extension + Profile Image.swift
//  Test2
//
//  Created by Рамил Гаджиев on 09.10.2021.
//

import UIKit

class ProfileCircleImage: UIView {
    
    var imageView: UIImageView = {
        var imageiew = UIImageView()
        imageiew.translatesAutoresizingMaskIntoConstraints = false
        imageiew.clipsToBounds = true
        imageiew.contentMode = .scaleAspectFill
        imageiew.image = #imageLiteral(resourceName: "person")
        imageiew.layer.borderWidth = 3
        imageiew.layer.borderColor = UIColor.white.cgColor
        return imageiew
    }()
    
    var button: UIButton = {
        var button = UIButton(type:.system)
        button.setImage(UIImage(systemName: "folder.badge.plus"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(button)
        setupConstraints ()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width/2
    }
    
    func setupConstraints () {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 42),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
    }
    
}

