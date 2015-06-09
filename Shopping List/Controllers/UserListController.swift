//
//  UserListController.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit
import MessageUI


class UserListController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate, ItemViewCellDelegate, MFMessageComposeViewControllerDelegate {
    
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
            DAORemoto.sharedInstance.allProductsOfList(list!, callback: { (arrayProducts : [Product]) -> Void in
                self.products = arrayProducts
                self.collectionView?.reloadData()
            })
            //self.collectionView?.reloadData()
        }
    }
    
    func share(sender: UIBarButtonItem){
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .ActionSheet)

    
        let addMembersAction = UIAlertAction(title: "Add Members to List", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showAddMembers()
        })
        
        let smsAction = UIAlertAction(title: "Send List by SMS", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showSMS()
        })
        
        let emailAction = UIAlertAction(title: "Send List by E-mail", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.mail_sender.productNames = self.products
            let mailComposeViewController = self.mail_sender.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.mail_sender.showSendMailErrorAlert()
            }

        })

        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in

        })
        
        optionMenu.addAction(addMembersAction)
        optionMenu.addAction(emailAction)
        optionMenu.addAction(smsAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        if !textField.isEqual(reusableView?.newItemTextField) {
            let title = (self.navigationItem.titleView as! TitleTextField).text
            DAORemoto.sharedInstance.changeNameOfList(title, list: self.list!)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.isEqual(reusableView?.newItemTextField) {
            let product = Product()
            product.name = textField.text
            textField.text = ""
            
            DAORemoto.sharedInstance.addProductToList(product.name, list: self.list!) 
            
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
    
    
    //Funcao para pegar amigos do facebook q estao conectados no app.
    func showAddMembers() {
        let friendRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil, HTTPMethod: "GET")
        friendRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println(result)
                let friends: AnyObject? = result.valueForKey("data")
                let friendNames: [String] = friends?.valueForKey("name") as! [String]
                let friendIDs: [String] = friends?.valueForKey("id") as! [String]
//                let friendPics: [String] = friends?.valueForKey("url") as! [String]
//                println("User Name is: \(friendNames))")
                
                
                let friendsList: FriendsListController
                friendsList = FriendsListController()
                friendsList.friendNames = friendNames
                friendsList.friendIDs = friendIDs
//                friendsList.friendPics = friendPics
                friendsList.list = self.list
                
                
                
                self.navigationController?.pushViewController(friendsList, animated: true)

            }
        })
    }
    
    //Função para enviar o sms
    func showSMS() {
        
        if( MFMessageComposeViewController.canSendText() ) {
            
            var productNameDisplay = ""
            for var i = 0 ; i < products.count ; i++ {
                productNameDisplay += "\(i+1) - \(products[i].name) \(products[i].cubage), \(products[i].brand)"
            }
            
            var messageController : MFMessageComposeViewController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self
            messageController.body = productNameDisplay
            self.presentViewController(messageController, animated: true, completion: nil)
            
        } else {
            
            print("O celular não tem opção para enviar mensagem de texto! \n")
            
        }
        
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //Aqui pode saber se o sms foi enviado com sucesso ou não, mas acho desnecessário no momento!
    }
    


}
