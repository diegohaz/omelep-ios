//
//  UserListController.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit
import MessageUI


class UserListController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate, ItemViewCellDelegate {
    
    var reusableView: UserListView?
    var collectionView: UICollectionView?
    var list: List?
    var products = [Product]()
    var isNew = false
    
    var mail_sender: MailSender! = MailSender()


    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let title = TitleTextField(frame: CGRectMake(0, 0, 180, 32))
        title.text = self.list?.name
        title.delegate = self
        navigationItem.titleView = title
        
        if isNew {
            reusableView?.newItemTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if list != nil {
            self.products = list!.returnProduct()
            self.collectionView?.reloadData()
        }
    }
    
    func share(sender: UIBarButtonItem){
        let mailComposeViewController = mail_sender.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.mail_sender.showSendMailErrorAlert()
        }
    }
    
    func doneItem(cell: ItemViewCell) {
        let indexPath = collectionView!.indexPathForCell(cell)
        
        DAORemoto.sharedInstance.deleteProductFromList(products[indexPath!.row], list: self.list!)

        products.removeAtIndex(indexPath!.row)
        collectionView!.reloadData()
    }
    
    func removeItem(cell: ItemViewCell) {
        let indexPath = collectionView!.indexPathForCell(cell)
        
        DAORemoto.sharedInstance.deleteProductFromList(products[indexPath!.row], list: self.list!)
        
        products.removeAtIndex(indexPath!.row)
        collectionView!.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.isEqual(reusableView?.newItemTextField) {
            let product = Product()
            product.name = textField.text
            textField.text = ""
            
            DAORemoto.sharedInstance.addProductToList(product.name, list: self.list!) { (list) -> Void in
                
            }
            
            products.insert(product, atIndex: 0)
            collectionView!.reloadData()
            collectionView?.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
            
            return true
        } else {
            let title = (self.navigationItem.titleView as! TitleTextField).text
            DAORemoto.sharedInstance.changeNameOfList(title, list: self.list!)
            
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

}
