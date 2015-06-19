//
//  AutoCompleteController.swift
//  Shopping List
//
//  Created by Bruno Baring on 6/19/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class AutoCompleteController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView: UITableView  =   UITableView()
    
    var items: [String] = ["Viper", "X", "Games"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.frame         =   CGRectMake(0, 0, self.view.frame.width, self.view.frame.height);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.backgroundColor = UIColor(white: 100/255, alpha: 0.5)
        
        self.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}