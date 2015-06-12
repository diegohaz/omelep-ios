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
        println("passou no maincontroller")
        self.navigationBar.tintColor = UIColor(red: 33/255, green: 141/255, blue: 181/255, alpha: 1)
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationBar.backItem?.title = ""
        self.pushViewController(LoginController.sharedInstance, animated: true)
    }

}
