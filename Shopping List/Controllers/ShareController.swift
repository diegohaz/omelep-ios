//
//  ShareController.swift
//  Shopping List
//
//  Created by Bruno Baring on 6/10/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit
import MessageUI

class ShareController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate{
    
    var mail_sender : MailSender! = MailSender()
    
    var list : List!
    
    var friends : [User] = []
    var friendInList : [User] = []
    
    override func viewDidLoad() {
        
        NSUserDefaults.standardUserDefaults().setObject("Share", forKey: "Last Screen")
        
        let blockView = UIControl(frame: self.view.frame)
        blockView.backgroundColor = UIColor.blackColor()
        blockView.alpha = 0.5
        blockView.addTarget(self, action: "dismissShareController", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(blockView)
        
        
        var frontView: UIView = UIView(frame: CGRectMake(self.view.frame.width/20.645, self.view.frame.height/6.418, self.view.frame.width/1.109, self.view.frame.height/1.452))
        frontView.backgroundColor     = UIColor.whiteColor()
        frontView.layer.cornerRadius  = 5;
        frontView.layer.masksToBounds = true;
        self.view.addSubview(frontView)
        
        //Pegando os usuários que vão ser mostrados:
        friends = DAOLocal.sharedInstance.allUserOutOfThisList(list)
        friendInList = list.returnUser()
        
        
        //label
        let title: UILabel = UILabel(frame: CGRectMake(0,0,frontView.frame.width,frontView.frame.height/13.016))
        title.text = "Membros da Lista"
        title.textAlignment = NSTextAlignment.Center
        frontView.addSubview(title)
        
        
        //collectionview
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: frontView.frame.width/16.941, bottom: 0, right: frontView.frame.width/16.941)
        layout.itemSize = CGSize(width: 48, height: 48)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        
        Collection = UICollectionView(frame: CGRectMake(0, title.frame.height, frontView.frame.width, frontView.frame.height/5.578), collectionViewLayout: layout)
        Collection.dataSource = self
        Collection.scrollEnabled = true
        Collection.delegate = self
        Collection.registerClass(SharedUsersCell.self, forCellWithReuseIdentifier: "SharedUsersCell")
        Collection.backgroundColor = UIColor.whiteColor()//.colorWithAlphaComponent(0)
        
        
        var bottomBorder: CALayer = CALayer()
        bottomBorder.borderColor  = UIColor.grayColor().CGColor
        bottomBorder.borderWidth  = 1
        //gambiarra braba aqui na linha de baixo
        bottomBorder.frame = CGRectMake(-100, Collection.frame.height-1, frontView.frame.width + 1000, 1)
        Collection.layer.addSublayer(bottomBorder)
        frontView.addSubview(Collection!)
        
        
        //tableview
        tableView.frame           = CGRectMake(0, Collection.frame.height + Collection.frame.origin.y, frontView.frame.width, frontView.frame.height/1.957);
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: CGRectZero)
        frontView.addSubview(tableView)
        
        
        //button Email
        let sendByEmail: UIButton = UIButton(frame: CGRectMake( 0, tableView.frame.height + tableView.frame.origin.y, frontView.frame.width, frontView.frame.height / 8.875))
        sendByEmail.setTitle("Enviar por Email", forState: UIControlState.Normal)
        sendByEmail.setTitleColor(UIColor(red: 33/255, green: 141/255, blue: 181/255, alpha: 1.0), forState: UIControlState.Normal)
        sendByEmail.addTarget(self, action: "sendEmail", forControlEvents: UIControlEvents.TouchUpInside)
        let topLine: UIView = UIView(frame: CGRectMake(0, 0, sendByEmail.frame.size.width, 1))
        topLine.backgroundColor = UIColor.grayColor()
        sendByEmail.addSubview(topLine)
        frontView.addSubview(sendByEmail)
        
        
        //button SMS
        let sendBySMS: UIButton = UIButton(frame: CGRectMake( 0, sendByEmail.frame.height + sendByEmail.frame.origin.y, frontView.frame.width, frontView.frame.height / 8.775))
        sendBySMS.setTitle("Enviar por SMS", forState: UIControlState.Normal)
        sendBySMS.setTitleColor(UIColor(red: 33/255, green: 141/255, blue: 181/255, alpha: 1.0), forState: UIControlState.Normal)
        sendBySMS.addTarget(self, action: "sendSMS", forControlEvents: UIControlEvents.TouchUpInside)
        let topLine2: UIView = UIView(frame: CGRectMake(0, 0, sendBySMS.frame.size.width, 1))
        topLine2.backgroundColor = UIColor.grayColor()
        sendBySMS.addSubview(topLine2)
        frontView.addSubview(sendBySMS)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        trackScreen("Share")
    }
    
    //tableview
    var tableView: UITableView  =   UITableView()
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = friends[indexPath.row].name
        //cell.imageView!.image = DAOLocal.sharedInstance.imageOfUser(friendInList[indexPath.row])
        
        var frame = cell.imageView!.frame
        let imageSize = DAOLocal.sharedInstance.imageOfUser(friends[indexPath.row]).size.width
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
        return friendInList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = Collection.dequeueReusableCellWithReuseIdentifier("SharedUsersCell", forIndexPath: indexPath) as! SharedUsersCell
        
        cell.imageView.image = DAOLocal.sharedInstance.imageOfUser(friendInList[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < friendInList.count{
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
    //    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
    //
    //        self.dismissViewControllerAnimated(true, completion: nil)
    //
    //        //Aqui pode saber se o sms foi enviado com sucesso ou não, mas acho desnecessário no momento!
    //    }
    
    func sendEmail(){
        println("sendEmail")
        //        self.mail_sender.productNames = self.products
        let mailComposeViewController = self.mail_sender.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.mail_sender.showSendMailErrorAlert()
        }
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    func removeUserShareFromList(i: Int) {
        
        if( friendInList[i] != DAOLocal.sharedInstance.readUser() ) {
        
            DAORemoto.sharedInstance.removeRelationUserList(friendInList[i], list: list)
        
            friends.insert(friendInList[i], atIndex: 0)
            friendInList.removeAtIndex(i)
            
            trackEvent("Share Facebook", action: "Remove", label: friends[0].id, value: friendInList.count)
        
            tableView.reloadData()
            Collection.reloadData()
        
        }
    
    }
    
    func addUserShareToList(i: Int){
        DAORemoto.sharedInstance.createRelationUserList(friends[i], list: list)
        
//*** DEU CONFLITO AQUI. ASSIM FAZ MAIS SENTIDO *****
        friendInList.insert(friends[i], atIndex: 0)
//        friendInList.insert(friends[i], atIndex: friendInList.count)
//*** DEU CONFLITO AQUI. ASSIM FAZ MAIS SENTIDO *****
        
        
        friends.removeAtIndex(i)
        trackEvent("Share Facebook", action: "Add", label: friendInList[0].id, value: friendInList.count)

        tableView.reloadData()
        Collection.reloadData()

    }
    
    
    func dismissShareController(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
