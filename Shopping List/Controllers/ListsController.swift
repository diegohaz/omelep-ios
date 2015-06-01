//
//  ListsController.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

@objc
protocol ListsControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}

class ListsController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ItemViewCellDelegate {
    
    static let sharedInstance = ListsController()
    
    var delegate: CenterViewControllerDelegate?
    
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
    
    override func viewDidAppear(animated: Bool) {
        DAORemoto.sharedInstance.allListOfUser { lists in
            self.lists = lists
            self.collectionView?.reloadData()
        }
    }
    
    func add(sender: UIBarButtonItem) {
        let controller = UserListController()
        controller.isNew = true
        
        let list = List()
        list.name = "List"
        
        DAORemoto.sharedInstance.saveNewList(list)
        
        controller.list = list
        
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    func openMenu(sender: UIBarButtonItem) {
        println("loadar o menu")
        delegate?.toggleLeftPanel?()
    }
    
    func removeItem(cell: ItemViewCell) {
        let indexPath = collectionView?.indexPathForCell(cell)
        
        DAORemoto.sharedInstance.deleteList(self.lists[indexPath!.row])
        
        self.lists.removeAtIndex(indexPath!.row)
        self.collectionView?.reloadData()
    }
    
    func doneItem(cell: ItemViewCell) {
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = UserListController()
        
        controller.list = self.lists[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lists.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ListCell", forIndexPath: indexPath) as! ListViewCell
        let list = self.lists[indexPath.row]
        var products = [String]()
        
        cell.delegate = self
        cell.label.text = list.name
        
        for product in list.returnProduct() {
            products.append(product.name)
        }
        
        cell.itemsLabel.text = ", ".join(products)
        
        return cell
    }

}
