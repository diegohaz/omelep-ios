//
//  UserListController.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class UserListController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    static let sharedInstance = UserListController()
    var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List"
        collectionView = UserListView(frame: self.view.bounds)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "ItemViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Share"), style: UIBarButtonItemStyle.Plain, target: self, action: "share:")
        
        view.addSubview(self.collectionView!)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemCell", forIndexPath: indexPath) as! ItemViewCell
        //let list = self.lists[indexPath.row]
        
        cell.label.text = "Item"
        
        return cell
    }

}
