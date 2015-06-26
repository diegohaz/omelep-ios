//
//  UserListController.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit
import MessageUI


class UserListController: GAITrackedViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate, ItemViewCellDelegate {
    
    var reusableView: UserListView?
    var collectionView: UICollectionView?
    var list: List?
    var products = [Product]() /* qual a diferenca desse products para o products atributo de lists? Preciso saber para medir no Analytics*/
    var isNew = false
    
    var mail_sender: MailSender! = MailSender()
    
    var shareController: ShareController!
    
    var autoComplete: AutoComplete!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "User List"
        
        NSUserDefaults.standardUserDefaults().setObject("UserLists", forKey: "Last Screen")
        
        // Reusable View
        reusableView = NSBundle.mainBundle().loadNibNamed("UserListView", owner: self, options: [:])[0] as? UserListView
        view = reusableView
        
        //autoComplete
        autoComplete = AutoComplete(frame: CGRectMake(0,self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.height - 7.5,self.view.frame.width, self.view.frame.height))
        
        // Collection View
        collectionView = reusableView?.collectionView
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "ItemViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        // Text Field
        reusableView?.newItemTextField.delegate = self
        
        // Navigation
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Share"), style: UIBarButtonItemStyle.Plain, target: self, action: "share:")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backCharacter.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "goback")
        //        navigationItem.backBarButtonItem = UIBarButtonItem(title: "oiii", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        
        
        let title = TitleTextField(frame: CGRectMake(0, 0, 180, 32))
        title.text = self.list?.name
        title.delegate = self
        navigationItem.titleView = title
        
        if isNew {
            reusableView?.newItemTextField.becomeFirstResponder()
        }
        
        reusableView?.newItemTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addSearchedProduct:", name:"addSearchedProductToList", object: nil)
        
        
    }
    
    func goback(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func textFieldDidChange(textField: UITextField) {
        
        autoComplete.wordChanged(textField.text)
        
        
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        trackScreen("UserLists")
        
        if list != nil {
            DAORemoto.sharedInstance.allProductsOfList(list!, callback: { (arrayProducts : [Product]) -> Void in
                self.products = arrayProducts
                self.collectionView?.reloadData()
            })
        }
    }
    
    
    
    func share(sender: UIBarButtonItem){
        
        shareController = ShareController()
        shareController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        shareController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        shareController.list = list
        
        self.presentViewController(shareController, animated: true, completion: nil)
        
    }
    
    func doneItem(cell: ItemViewCell) {
        let indexPath = collectionView!.indexPathForCell(cell)
        trackEvent("Products Operations", action: "Done Product From List", label: products[indexPath!.row].name, value: self.products.count)
        
        DAORemoto.sharedInstance.deleteProductFromList(products[indexPath!.row], list: self.list!)
        
        products.removeAtIndex(indexPath!.row)
        collectionView!.reloadData()
    }
    
    func removeItem(cell: ItemViewCell) {
        let indexPath = collectionView!.indexPathForCell(cell)
        trackEvent("Products Operations", action: "Remove Product From List", label: products[indexPath!.row].name, value: self.products.count)
        
        DAORemoto.sharedInstance.deleteProductFromList(products[indexPath!.row], list: self.list!)
        
        products.removeAtIndex(indexPath!.row)
        collectionView!.reloadData()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if !textField.isEqual(reusableView?.newItemTextField) {
            let title = (self.navigationItem.titleView as! TitleTextField).text
            DAORemoto.sharedInstance.changeNameOfList(title, list: self.list!)
            trackEvent("Product Operations", action: "Edit List Name", label: title, value: self.products.count)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        autoComplete.removeFromSuperview()
        autoComplete = nil
        if textField.isEqual(reusableView?.newItemTextField) {
            let product = Product()
            product.name = textField.text
            textField.text = ""
            
            DAORemoto.sharedInstance.addProductToList(product.name, list: self.list!)
            
            products.insert(product, atIndex: 0)
            trackEvent("Product Operations", action: "Add New Product to List", label: product.name, value: self.products.count)
            collectionView!.reloadData()
            collectionView?.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
            
            return true
        } else {
            let title = (self.navigationItem.titleView as! TitleTextField).text
            DAORemoto.sharedInstance.changeNameOfList(title, list: self.list!)
            trackEvent("Lists Operations", action: "Edit List Name", label: title, value: self.products.count)
            
            return true
        }
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
        
        cell.delegate = self
        cell.label.text = product.name
        
        return cell
    }
    
    
    func addSearchedProduct(notification: NSNotification){
        let product = Product()
        product.name = notification.object as! String
        
        DAORemoto.sharedInstance.addProductToList(product.name, list: self.list!)
        
        products.insert(product, atIndex: 0)
        trackEvent("Products Operations", action: "Add Found Product to List", label: product.name, value: self.products.count)
        collectionView!.reloadData()
        collectionView?.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
    }
    
}
