//
//  BaseViewController.swift
//  ToDo
//
//  Created by Даниил Симахин on 27.10.2022.
//

import UIKit

class BaseViewController<T: UIView>: UIViewController {

    var baseView: T { view as! T }
    
    override func loadView() {
        view = T()
        setDelegates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() { }
    func setDelegates() { }
}
