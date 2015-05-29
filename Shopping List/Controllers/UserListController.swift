//
//  UserListController.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class UserListController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate, ItemViewCellDelegate {
    
    static let sharedInstance = UserListController()
    var reusableView: UserListView?
    var collectionView: UICollectionView?
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List"
        
        // Reusable View
        reusableView = NSBundle.mainBundle().loadNibNamed("UserListView", owner: self, options: [:])[0] as? UserListView
        view = reusableView
        
        // Collection View
        collectionView = reusableView?.collectionView
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "ItemViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        // Text Field
        reusableView?.newItemTextField.delegate = self
        
        // Navigation
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Share"), style: UIBarButtonItemStyle.Plain, target: self, action: "share:")
        
        // Populate products
        for i in 0...18 {
            products.append(Product())
        }
    }
    
    func doneItem(cell: ItemViewCell) {
        let indexPath = collectionView!.indexPathForCell(cell)

        products.removeAtIndex(indexPath!.row)
        collectionView!.reloadData()
    }
    
    func removeItem(cell: ItemViewCell) {
        let indexPath = collectionView!.indexPathForCell(cell)
        
        products.removeAtIndex(indexPath!.row)
        collectionView!.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = CGSize(width: self.view.bounds.width, height: 48)
        
        return size
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemCell", forIndexPath: indexPath) as! ItemViewCell
        //let list = self.products[indexPath.row]
        
        cell.delegate = self
        cell.label.text = "Item"
        
        return cell
    }

}
