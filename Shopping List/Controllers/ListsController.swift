//
//  ListsController.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class ListsController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    static let sharedInstance = ListsController()
    
    var collectionView: UICollectionView?
    var lists = [List]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Lists"
        collectionView = ListsView(frame: self.view.bounds)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "ListViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
        collectionView!.registerNib(UINib(nibName: "SuggestionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuggestionCell")
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu"), style: .Plain, target: self, action: "openMenu:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add:")
        
        view.addSubview(self.collectionView!)
    }
    
    func add(sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(UserListController.sharedInstance, animated: true)

    }
    
    func openMenu(sender: UIBarButtonItem) {
        // open menu
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ListCell", forIndexPath: indexPath) as! ListViewCell
        //let list = self.lists[indexPath.row]
        
        cell.label.text = "Nome da lista"
        cell.items.text = "Item 1, item 2, item 3..."
        
        return cell
    }

}
