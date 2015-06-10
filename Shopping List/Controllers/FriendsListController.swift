//
//  FriendsListController.swift
//  Shopping List
//
//  Created by Bruno Baring on 6/1/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class FriendsListController: GAITrackedViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    var tableView: UITableView =   UITableView()
    
    var friendNames: [String]  = []
    var friendIDs: [String]    = []
    var friendPics: [String]   = []
    
    var barSearch: UISearchBar = UISearchBar()
    var is_searching:Bool!
    var searchingNamesArray:NSMutableArray!
    var searchingIDsArray:NSMutableArray!
    var searchingPicsArray:NSMutableArray!
    
    
    var list: List!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "Facebook Share Screen"
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //        barSearch.frame = CGRectMake(0, self.navigationController!.navigationBar.bounds.height, self.view.bounds.width, 200)
        
        barSearch.frame         = CGRectMake(0, self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height, self.view.bounds.width, 50)
        barSearch.delegate      = self
        
        tableView.frame         = CGRectMake(0, barSearch.frame.height, self.view.bounds.width, self.view.bounds.height - self.navigationController!.navigationBar.bounds.height);
        tableView.delegate      = self
        tableView.dataSource    = self
        
        self.view.addSubview(tableView)
        self.view.addSubview(barSearch)
        
        searchingNamesArray     = []
        searchingIDsArray       = []
        searchingPicsArray      = []
        is_searching            = false
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if is_searching == true{
            return searchingNamesArray.count
        }else{
            return friendNames.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        
        if is_searching == true{
            cell.textLabel!.text = searchingNamesArray[indexPath.row] as? String
        }else{
            cell.textLabel!.text = friendNames[indexPath.row]
        }
    
        return cell
        
        //        let url = NSURL(string: friendPics[indexPath.row])
        //        let data = NSData(contentsOfURL: url!)
        //        var image : UIImage = UIImage(data: data!)!
        //        cell.imageView!.image = image
        
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if barSearch.text.isEmpty{
            is_searching = false
            tableView.reloadData()
        } else {
            println(" search text %@ ",barSearch.text as NSString)
            is_searching = true
            searchingNamesArray.removeAllObjects()
            searchingPicsArray.removeAllObjects()
            searchingIDsArray.removeAllObjects()
            for var index = 0; index < friendNames.count; index++
            {
                var currentString = friendNames[index]
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchingNamesArray.addObject(currentString)
                    
                }
            }
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("fbID do amigo: \(friendIDs[indexPath.row])")
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: true)
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }
        DAORemoto.sharedInstance.addFriendToList(friendIDs[indexPath.row], list: list)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}