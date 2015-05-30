//
//  ListViewCell.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class ListViewCell: ItemViewCell {
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var shareImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shareImage.image = shareImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        shareImage.tintColor = UIColor.whiteColor()
    }
}
