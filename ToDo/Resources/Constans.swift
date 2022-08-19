//
//  Constans.swift
//  ToDo
//
//  Created by Даниил Симахин on 19.08.2022.
//

import Foundation
import UIKit

enum Constans {
    enum Colors {
        static let backgroundColor = UIColor(named: "backgroundColor")
        static let checkboxColor = UIColor(named: "checkboxColor")
        static let navBarColor = UIColor(named: "navBarColor")
        static let navBarItemColor = UIColor(named: "navBarItemColor")
        static let secondaryTextColor = UIColor(named: "secondaryTextColor")
        static let tableViewColor = UIColor(named: "tableViewColor")
        static let textColor = UIColor(named: "textColor")
    }
    
    enum Texts {
        static let titleTaskList = "Мои дела"
        static let titleAddingTask = "Дело"
        
        static let importance = "Важность"
        static let makeUp = "Сделать до"
        
        static let placeholderForAddTask = "Что надо сделать?"
    }
}
