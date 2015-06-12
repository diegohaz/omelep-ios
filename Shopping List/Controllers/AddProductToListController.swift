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
    
    override func viewDidLoad() {
        var frontView: UIView = UIView(frame: CGRectMake(15, 86, self.view.frame.width - 2 * 15, self.view.frame.height - 2 * 86))
        
        frontView.backgroundColor     = UIColor.whiteColor()
        frontView.layer.cornerRadius  = 5;
        frontView.layer.masksToBounds = true;
        self.view.addSubview(frontView)

        
        //label
        let title: UILabel = UILabel(frame: CGRectMake(0,0,frontView.frame.width,46))
        title.text = "Adicionar à:"
        title.textAlignment = NSTextAlignment.Center
        var bottomBorder: CALayer = CALayer()
        bottomBorder.borderColor = UIColor.grayColor().CGColor
        bottomBorder.borderWidth = 1
        //gambiarra braba aqui na linha de baixo
        bottomBorder.frame = CGRectMake(0, title.frame.height-1, frontView.frame.width, 1)
        title.layer.addSublayer(bottomBorder)
        frontView.addSubview(title)

        
        //tableview
        tableView.frame           =   CGRectMake(0, title.frame.height, frontView.frame.width, 343);
        tableView.delegate        =   self
        tableView.dataSource      =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        frontView.addSubview(tableView)
        
    }
    
    
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
}
