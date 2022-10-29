//
//  AppendTaskButton.swift
//  ToDo
//
//  Created by Даниил Симахин on 26.10.2022.
//

import UIKit

class AppendTaskButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppendTaskButton {
    func setup() {
        backgroundColor = Constans.Colors.navBarTaskColor
        tintColor = .white
        
        let font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        let config = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        setImage(image, for: .normal)
        
        layer.cornerRadius = 25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
