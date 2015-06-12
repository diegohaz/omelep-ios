//
//  AddProductToListController.swift
//  Shopping List
//
//  Created by Bruno Baring on 6/11/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class AddProductToListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var lists: [List] = []
    var products: [Product] = []
    var frontView: UIView!
    
    override func viewDidLoad() {
        
        let blockView = UIControl(frame: self.view.frame)
        blockView.backgroundColor = UIColor.blackColor()
        blockView.alpha = 0.5
        blockView.addTarget(self, action: "dismissShareController", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(blockView)
        
        frontView = UIView(frame: CGRectMake(self.view.frame.width/20.645, self.view.frame.height/6.418, self.view.frame.width/1.109, self.view.frame.height/1.452))
        frontView.backgroundColor     = UIColor.whiteColor()
        frontView.layer.cornerRadius  = 5;
        frontView.layer.masksToBounds = true;
        self.view.addSubview(frontView)

        
        //label
        let title: UILabel = UILabel(frame: CGRectMake(0,0,frontView.frame.width,frontView.frame.height/8.408))
        title.text = "Adicionar à lista:"
        title.textAlignment = NSTextAlignment.Center
        var bottomBorder: CALayer = CALayer()
        bottomBorder.borderColor = UIColor.grayColor().CGColor
        bottomBorder.borderWidth = 1
        bottomBorder.frame = CGRectMake(0, title.frame.height-1, frontView.frame.width, 1)
        title.layer.addSublayer(bottomBorder)
        frontView.addSubview(title)

        
        //tableview
        tableView.frame           =   CGRectMake(0, title.frame.height, frontView.frame.width, frontView.frame.height/1.31);
        tableView.delegate        =   self
        tableView.dataSource      =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.backgroundColor = UIColor.clearColor()
        let line: UIView = UIView(frame: CGRectMake(frontView.frame.width / 8.013, tableView.frame.origin.y, 1, tableView.frame.height))
        line.backgroundColor = UIColor(red: 33/255, green: 141/255, blue: 181/255, alpha: 1.0)
        frontView.addSubview(line)
        frontView.addSubview(tableView)
        
        
        //button NewList
        let newList: UIButton = UIButton(frame: CGRectMake( 0, tableView.frame.height + tableView.frame.origin.y, frontView.frame.width, frontView.frame.height / 8.775))
        newList.setTitle("Criar Nova Lista", forState: UIControlState.Normal)
        newList.setTitleColor(UIColor(red: 33/255, green: 141/255, blue: 181/255, alpha: 1.0), forState: UIControlState.Normal)
        newList.addTarget(self, action: "addProductToNEWList", forControlEvents: UIControlEvents.TouchUpInside)
        let topLine: UIView = UIView(frame: CGRectMake(0, 0, newList.frame.size.width, 1))
        topLine.backgroundColor = UIColor.grayColor()
        newList.addSubview(topLine)
        frontView.addSubview(newList)
        
    }
    
    //tableview
    var tableView: UITableView  =   UITableView()
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = self.lists[indexPath.row].name
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //funcs
    func addProductToNEWList(){
        
    }
}
