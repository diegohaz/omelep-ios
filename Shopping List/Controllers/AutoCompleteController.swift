//
//  AutoCompleteController.swift
//  Shopping List
//
//  Created by Bruno Baring on 6/19/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class AutoCompleteController: UIView,UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView: UITableView  =   UITableView()
    
    var items: [String] = ["Viper", "X", "Games"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.frame         =   self.frame
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.addSubview(tableView)
        
        tableView.backgroundColor = UIColor(white: 100/255, alpha: 0.5)
        self.backgroundColor = UIColor.clearColor()

//        self.frame.origin.y = self.navigationController!.navigationBar.frame.size.height
        
//        var frontView: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.width/1.109, self.view.frame.height/1.452))
//        frontView.backgroundColor     = UIColor.whiteColor()
//        frontView.layer.cornerRadius  = 5;
//        frontView.layer.masksToBounds = true;
//        self.addSubview(frontView)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    
    
}