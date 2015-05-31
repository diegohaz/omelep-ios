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
        
        var list : List = List()
        list.name = "Almoço de Natal"
        DAORemoto.sharedInstance.saveNewList(list)
        
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
        let controller = UserListController()
        controller.isNew = true
        
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    func openMenu(sender: UIBarButtonItem) {
        println("loadar o menu")
        delegate?.toggleLeftPanel?()
    }
    
    func removeItem(cell: ItemViewCell) {
        
    }
    
    func doneItem(cell: ItemViewCell) {
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = UserListController()
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ListCell", forIndexPath: indexPath) as! ListViewCell
        //let list = self.lists[indexPath.row]
        
        cell.delegate = self
        cell.label.text = "Nome da lista"
        cell.itemsLabel.text = "Item 1, item 2, item 3..."
        
        return cell
    }

}
