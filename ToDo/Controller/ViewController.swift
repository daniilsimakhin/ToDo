//
//  ViewController.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var fileCache = FileCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        var item = ToDoItem(text: "hello se", importance: .important, deadline: nil, isComplete: false, dateCreated: Date(), dateChanged: nil)
        var item2 = ToDoItem(text: "sema", importance: .ordinary, deadline: nil, isComplete: false, dateCreated: Date(), dateChanged: nil)
        fileCache.addNewItem(item: item)
        fileCache.addNewItem(item: item2)
        fileCache.saveItems()
    }


}

