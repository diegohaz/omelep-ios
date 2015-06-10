//
//  ShareController.swift
//  Shopping List
//
//  Created by Bruno Baring on 6/10/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class ShareController: UIView{
    
//    init(){
//        super.init()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        println("entrou na share controller")
        self.backgroundColor = UIColor.redColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
