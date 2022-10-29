//
//  UIFontExtension.swift
//  ToDo
//
//  Created by Даниил Симахин on 28.10.2022.
//

import UIKit

extension UIFont {
    static let caption: UIFont = {
        var font = UIFont()
        font = .systemFont(ofSize: 15, weight: .regular)
        return font
    }()
    
    static let bold: UIFont = {
        var font = UIFont()
        font = .systemFont(ofSize: 15, weight: .bold)
        return font
    }()
    
    static let regular: UIFont = {
        var font = UIFont()
        font = .systemFont(ofSize: 17.5, weight: .regular)
        return font
    }()
}
