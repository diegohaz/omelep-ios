//
//  CenterViewController.swift
//  Shopping List
//
//  Created by Bruno Baring on 5/30/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController {
    
    var delegate: CenterViewControllerDelegate?
    
}
