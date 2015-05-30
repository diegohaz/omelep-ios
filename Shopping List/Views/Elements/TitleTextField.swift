//
//  TitleTextField.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class TitleTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textAlignment = .Center
        self.backgroundColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
