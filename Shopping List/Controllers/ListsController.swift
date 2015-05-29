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
        

//        title = "Lists"
//        collectionView = ListsView(frame: self.view.bounds)
//        collectionView!.dataSource = self
//        collectionView!.delegate = self
//        collectionView!.registerNib(UINib(nibName: "ListViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
//        collectionView!.registerNib(UINib(nibName: "SuggestionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuggestionCell")
//        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchList:")
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addList:")
//        
//        view.addSubview(self.collectionView!)
//        
//        lists = DAOLocal.sharedInstance.readLists()

        //MUITO IMPORTANTE:
        var l: List! = nil
        DAORemoto.sharedInstance.searchListFromID("-JqRtZDQGc0aodX-lNTy") { list in
            l = list
            println(l)
            
            
            
        }
        
        
        

        title = "Lists"
        collectionView = ListsView(frame: self.view.bounds)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "ListViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
        collectionView!.registerNib(UINib(nibName: "SuggestionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuggestionCell")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "search:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add:")
        
        view.addSubview(self.collectionView!)
    }
    
    func add(sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(UserListController.sharedInstance, animated: true)

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
