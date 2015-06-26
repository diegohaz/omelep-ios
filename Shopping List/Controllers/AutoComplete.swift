//
//  AutoCompleteController.swift
//  Shopping List
//
//  Created by Bruno Baring on 6/19/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class AutoComplete: UIView,UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView: UITableView  =   UITableView()
    
//    var results: [String] = ["teste1","teste2","teste3","teste4"]
    var results: [String] = []
    var word: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        tableView.frame         =   self.frame
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    func wordChanged(word: String){
        //            manda word para funcao de autocomplete
        tableView.reloadData()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.results.count == 0{
            return 1
        }else{
            return self.results.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        if self.results.count == 0{
            cell.textLabel?.text = "Não encontramos seu produto! :("
        }else{
            cell.textLabel?.text = self.results[indexPath.row]
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.results.count == 0{
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }else{
            NSNotificationCenter.defaultCenter().postNotificationName("addSearchedProductToList", object: results[indexPath.row])
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        println("You selected cell #\(indexPath.row)!")
    }
    
    
    
}