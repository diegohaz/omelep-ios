//
//  ListsController.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class ListsController: GAITrackedViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ItemViewCellDelegate {
    
    static let sharedInstance = ListsController()
    
    var collectionView: UICollectionView?
    var lists = [List]()
    
    var shareController: ShareController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "Lists"
        
        NSUserDefaults.standardUserDefaults().setObject("Lists", forKey: "Last Screen")

//        DAORemoto.sharedInstance.sincroniza { lists in
//            self.lists = lists
//            self.collectionView?.reloadData()
//        }
        
        self.navigationController?.navigationBarHidden = false

        
        title = "Minhas listas"
        collectionView = ListsView(frame: self.view.bounds)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "ListViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
        collectionView!.registerNib(UINib(nibName: "SuggestionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuggestionCell")
        
        navigationItem.hidesBackButton = true
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu"), style: .Plain, target: self, action: "openMenu:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add:")
        
        view.addSubview(self.collectionView!)
    }
    
    override func viewDidAppear(animated: Bool) {
        trackScreen("Lists")
        
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
        trackEvent("Lists Operations", action: "Add New List", label: list.name, value: lists.count)

        controller.list = list

        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    
    
    func openMenu(sender: UIBarButtonItem) {
        
//        let blockView = UIControl(frame: self.view.frame)
//        blockView.backgroundColor = UIColor.blackColor()
//        blockView.alpha = 0.5
//        self.view.addSubview(blockView)
//        
//        var addProductToListController: AddProductToListController = AddProductToListController()
//        addProductToListController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//        
//        self.presentViewController(addProductToListController, animated: true, completion: nil)
//       
//        
//        println("deu logout")
   
        
        FBSDKLoginManager().logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func removeItem(cell: ItemViewCell) {
        let indexPath = collectionView?.indexPathForCell(cell)
        
        DAORemoto.sharedInstance.deleteList(self.lists[indexPath!.row])
        trackEvent("Lists Operations", action: "Delete List", label: self.lists[indexPath!.row].name, value: 0 /* quero colocar a quantidade de produtos da lista aqui*/)

        
        self.lists.removeAtIndex(indexPath!.row)
        self.collectionView?.reloadData()
    }
    
    func doneItem(cell: ItemViewCell) { /* aqui deve ser o Share */
        let indexPath = collectionView?.indexPathForCell(cell)

        shareController = ShareController()
        shareController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        shareController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        shareController.list = self.lists[indexPath!.row]
        
        self.presentViewController(shareController, animated: true, completion: nil)
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = UserListController()
        
        controller.list = self.lists[indexPath.row]
        trackEvent("Lists Operations", action: "Open List", label: self.lists[indexPath.row].name, value: 0 /* quero colocar a quantidade de produtos da lista aqui*/)

        
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
