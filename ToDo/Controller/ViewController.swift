//
//  ViewController.swift
//  ToDo
//
//  Created by Даниил Симахин on 11.08.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var item = ToDoItem(text: "hello se", importance: .important, deadline: nil, isComplete: false, dateCreated: Date(), dateChanged: nil)
        print(item.json)
        let iitem = ToDoItem.parse(json: item.json)
        print(iitem)
    }


}

