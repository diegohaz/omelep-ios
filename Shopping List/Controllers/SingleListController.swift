//
//  SingleListController.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class SingleListController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    static let sharedInstance = SingleListController()
    
    var collectionView: UICollectionView?
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List"
        collectionView = ListsView(frame: self.view.bounds)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "ItemViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Incorporate"), style: .Plain, target: self, action: "incorporate:")
        
        view.addSubview(self.collectionView!)
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
        let product = self.products[indexPath.row]

        cell.label.text = product.name
        
        return cell
    }

}
