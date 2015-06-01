//
//  MainController.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class MainController: UINavigationController {
    
    static let sharedInstance = MainController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.tintColor = UIColor(red: 148/255, green: 30/255, blue: 16/255, alpha: 1)
        self.pushViewController(ListsController.sharedInstance, animated: true)
    }

}
