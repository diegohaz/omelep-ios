//
//  ShareController.swift
//  Shopping List
//
//  Created by Bruno Baring on 6/10/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit
import MessageUI

class ShareController: UIView, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate{
    
    
    var onListNames:  [String]     = []
    var onListIDs:    [String]     = []
    var onListPics:   [UIImage]    = []
    
    var offListNames: [String]     = []
    var offListIDs:   [String]     = []
    var offListPics:  [UIImage]    = []
    
    var mail_sender:   MailSender! = MailSender()
    
    var list:          List!
    var products:     [Product]    = []
    
    convenience init(productsFromCurrentList: [Product], currentList: List, frame: CGRect){
        self.init(frame: frame)
        products = productsFromCurrentList
        list = currentList
        
        println(products.first?.name)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        self.userInteractionEnabled = true
        self.backgroundColor     = UIColor.whiteColor()
        self.layer.cornerRadius  = 5;
        self.layer.masksToBounds = true;
        
        onListNames.insert("onName", atIndex: 0)
        onListIDs.insert("onIDs", atIndex: 0)
        onListPics.insert(UIImage(named: "teste.png")!, atIndex: 0)
//        offListNames.insert("offName", atIndex: 0)
//        offListIDs.insert("offIDs", atIndex: 0)
        offListPics.insert(UIImage(named: "teste.png")!, atIndex: 0)
        getFacebookFriendsFromUser()
        
        //label
        let title: UILabel = UILabel(frame: CGRectMake(self.frame.width/2 - 70, 10, 2 * 70, 20))
//        title.backgroundColor = UIColor.greenColor()
        title.text = "Membros da Lista"
        self.addSubview(title)
        
        
        //collectionview
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        Collection = UICollectionView(frame: CGRectMake(0, title.frame.origin.y + title.frame.height, self.frame.width, 70), collectionViewLayout: layout)
        Collection.dataSource = self
        Collection.scrollEnabled = true
        Collection.delegate = self
        Collection.registerClass(SharedUsersCell.self, forCellWithReuseIdentifier: "SharedUsersCell")
        Collection.backgroundColor = UIColor.whiteColor()//.colorWithAlphaComponent(0)
        self.addSubview(Collection!)
        
        
        
        //tableview
        tableView.frame         =   CGRectMake(0, 100, 320, 200);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: CGRectZero)
        let topLine3: UIView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 1))
        topLine3.backgroundColor = UIColor.grayColor()
        tableView.addSubview(topLine3)
        self.addSubview(tableView)
        
        
        //button Email
        let sendByEmail: UIButton = UIButton(frame: CGRectMake( 0, tableView.frame.height + tableView.frame.origin.y, frame.width, (frame.height - tableView.frame.origin.y - tableView.frame.height) / 2))
        sendByEmail.setTitle("Enviar por Email", forState: UIControlState.Normal)
        sendByEmail.setTitleColor(UIColor(red: 33/255, green: 141/255, blue: 181/255, alpha: 1.0), forState: UIControlState.Normal)
        sendByEmail.addTarget(self, action: "sendEmail", forControlEvents: UIControlEvents.TouchUpInside)
        let topLine: UIView = UIView(frame: CGRectMake(0, 0, sendByEmail.frame.size.width, 1))
        topLine.backgroundColor = UIColor.grayColor()
        sendByEmail.addSubview(topLine)
        self.addSubview(sendByEmail)
        
        
        //button SMS
        let sendBySMS: UIButton = UIButton(frame: CGRectMake( 0, sendByEmail.frame.height + sendByEmail.frame.origin.y, frame.width, (frame.height - tableView.frame.origin.y - tableView.frame.height) / 2))
        sendBySMS.setTitle("Enviar por SMS", forState: UIControlState.Normal)
        sendBySMS.setTitleColor(UIColor(red: 33/255, green: 141/255, blue: 181/255, alpha: 1.0), forState: UIControlState.Normal)
        sendBySMS.addTarget(self, action: "sendSMS", forControlEvents: UIControlEvents.TouchUpInside)
        let topLine2: UIView = UIView(frame: CGRectMake(0, 0, sendBySMS.frame.size.width, 1))
        topLine2.backgroundColor = UIColor.grayColor()
        sendBySMS.addSubview(topLine2)
        self.addSubview(sendBySMS)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    //tableview
    var tableView: UITableView  =   UITableView()
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offListNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.offListNames[indexPath.row]
        cell.imageView!.image = self.offListPics[indexPath.row]
        
        
        
        var frame = cell.imageView!.frame
        let imageSize = UIImage(named: "teste.png")!.size.width
        frame.size.height = imageSize
        frame.size.width  = imageSize
        cell.imageView!.frame = frame
        cell.imageView!.layer.cornerRadius = (cell.imageView!.frame.size.width / 2.0) - 11
        cell.imageView!.clipsToBounds = true
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        addUserShareToList(indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    //collectionview
    var Collection: UICollectionView!
    var qtdCells: Int = 9
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        println(onListPics.count)
        return onListPics.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = Collection.dequeueReusableCellWithReuseIdentifier("SharedUsersCell", forIndexPath: indexPath) as! SharedUsersCell
//        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        
        if indexPath.row == onListPics.count {
            cell.imageView.image = UIImage(named: "Boneco.png")
        } else {
            cell.imageView.image = onListPics[indexPath.row]
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < onListPics.count{
            removeUserShareFromList(indexPath.row)
        }
    }
    
    
    
    
    //actions
//    func showSMS() {
//        
//        if( MFMessageComposeViewController.canSendText() ) {
//            
////            var productNameDisplay = ""
////            for var i = 0 ; i < products.count ; i++ {
////                productNameDisplay += "\(i+1) - \(products[i].name) \(products[i].cubage), \(products[i].brand)"
////            }
//            
//            var messageController : MFMessageComposeViewController = MFMessageComposeViewController()
//            messageController.messageComposeDelegate = self
//            messageController.body = "Teste"
////            self.presentViewController(messageController, animated: true, completion: nil)
//            self.window?.rootViewController?.presentViewController(messageController, animated: true, completion: nil)
//        } else {
//            
//            print("O celular não tem opção para enviar mensagem de texto! \n")
//            
//        }
//        
//    }
//    
//    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
//        
//        controller.dismissViewControllerAnimated(true, completion: nil)
//        
//        //Aqui pode saber se o sms foi enviado com sucesso ou não, mas acho desnecessário no momento!
//    }
    
    func sendEmail(){
        println("sendEmail")
        //        self.mail_sender.productNames = self.products
        let mailComposeViewController = self.mail_sender.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            //            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            self.window?.rootViewController?.presentViewController(mailComposeViewController, animated: true, completion: nil)
            
        } else {
            self.mail_sender.showSendMailErrorAlert()
        }
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
    //
    //        self.dismissViewControllerAnimated(true, completion: nil)
    //
    //        //Aqui pode saber se o sms foi enviado com sucesso ou não, mas acho desnecessário no momento!
    //    }
    
    func removeUserShareFromList(i: Int){
        offListPics.insert(onListPics[i], atIndex: 0)
        onListPics.removeAtIndex(i)
        
        offListNames.insert(onListNames[i], atIndex: 0)
        onListNames.removeAtIndex(i)
        
        offListIDs.insert(onListIDs[i], atIndex: 0)
        onListIDs.removeAtIndex(i)
        
        tableView.reloadData()
        Collection.reloadData()
    }
    
    func addUserShareToList(i: Int){
        onListPics.insert(offListPics[i], atIndex: 0)
        offListPics.removeAtIndex(i)
        
        onListNames.insert(offListNames[i], atIndex: 0)
        offListNames.removeAtIndex(i)
        
        onListIDs.insert(offListIDs[i], atIndex: 0)
        offListIDs.removeAtIndex(i)
        
        tableView.reloadData()
        Collection.reloadData()
    }
    
    
    //auxs funcs
    func getFacebookFriendsFromUser(){
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
                
                //http://graph.facebook.com/[UID]/picture
                

                
                self.offListNames = friendNames
                self.offListIDs = friendIDs
                for var i = 0 ; i < self.offListNames.count ; i++ {
                    self.offListPics.insert(UIImage(named: "teste.png")!, atIndex: 0)
                }
                println(self.offListNames)
//                self.offListPics =
                self.tableView.reloadData()
                
            }
        })
    }
    
    
}
