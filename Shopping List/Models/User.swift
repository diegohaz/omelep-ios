//
//  User.swift
//  
//
//  Created by Matheus Falcão on 25/05/15.
//
//

import Foundation
import UIKit
import CoreData

@objc(User)

class User: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var family: AnyObject
    @NSManaged var id: String
    @NSManaged var lists: NSSet
    @NSManaged var tags: NSSet
    
    convenience init() {
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context : NSManagedObjectContext
        context = appDelegate.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext:context)
        
        self.name = ""
        self.email = ""
        self.id = ""
        
    }
    
}

extension User{
    
    func addList(list : List) {
        var items = self.mutableSetValueForKey("lists");
        items.addObject(list);
    }
    
    func returnList() -> [List] {
        var items = self.mutableSetValueForKey("lists")
        var array = items.allObjects
        return array as! [List]
    }
    
    func addTag(tag : Tag) {
        var items = self.mutableSetValueForKey("tags");
        items.addObject(tag);
    }
    
    func returnTags() -> [Tag] {
        var items = self.mutableSetValueForKey("tags")
        var array = items.allObjects
        return array as! [Tag]
    }
    
    
}
