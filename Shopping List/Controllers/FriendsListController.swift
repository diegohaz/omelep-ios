//
//  FriendsListController.swift
//  Shopping List
//
//  Created by Bruno Baring on 6/1/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

//import UIKit
//
//class FriendsListController: UIViewController,UITableViewDelegate, UITableViewDataSource {
//    
//    
//    var tableView: UITableView  =   UITableView()
//    
//    var friendNames: [String] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        tableView.frame         =   CGRectMake(0, 50, 320, 200);
//        tableView.delegate      =   self
//        tableView.dataSource    =   self
//        
//        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        
//        self.view.addSubview(tableView)
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.items.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
//        
//        cell.textLabel?.text = self.items[indexPath.row]
//        
//        return cell
//        
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        println("You selected cell #\(indexPath.row)!")
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//}