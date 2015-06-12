//
//  UserListView.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class UserListView: UIView {
    @IBOutlet weak var newItemTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var plusButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "Row")!)
        self.plusButton.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
    }
}
