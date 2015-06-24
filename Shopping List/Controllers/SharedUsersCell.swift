//
//  SharedUsersCell.swift
//  Shopping List
//
//  Created by Bruno Baring on 6/10/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class SharedUsersCell: UICollectionViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var textLabel: UILabel = UILabel()
    var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
//        imageView.backgroundColor = UIColor.greenColor()//.colorWithAlphaComponent(0)
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.layer.borderWidth = 1.0;
//        imageView.layer.borderColor = UIColor.redColor().CGColor
        imageView.clipsToBounds = true;
        contentView.addSubview(imageView)
        
        let textFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/3)
        textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)
    }
}


    