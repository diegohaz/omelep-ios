//
//  FriendsListController.swift
//  Shopping List
//
//  Created by Bruno Baring on 6/1/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class FriendsListController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView: UITableView  =   UITableView()
    
    var friendNames: [String] = []
    var friendIDs: [String] = []
    var friendPics: [String] = []
    
    
    var list: List!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.frame         =   CGRectMake(0, self.navigationController!.navigationBar.bounds.height, self.view.bounds.width, self.view.bounds.height - self.navigationController!.navigationBar.bounds.height);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.friendNames[indexPath.row]
        
//        let url = NSURL(string: friendPics[indexPath.row])
//        let data = NSData(contentsOfURL: url!)
//        var image : UIImage = UIImage(data: data!)!
//        cell.imageView!.image = image
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("fbID do amigo: \(friendIDs[indexPath.row])")
        DAORemoto.sharedInstance.addFriendToList(friendIDs[indexPath.row], list: list)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}