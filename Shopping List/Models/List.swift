//
//  List.swift
//  
//
//  Created by Matheus Falcão on 25/05/15.
//
//

import Foundation
import CoreData
import UIKit

@objc(List)

class List: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var localID: NSNumber
    @NSManaged var name: String
    @NSManaged var photo: NSData
    @NSManaged var updatedDate: NSDate
    @NSManaged var products: NSSet
    @NSManaged var tags: NSSet

    
    convenience init() {
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context : NSManagedObjectContext
        context = appDelegate.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("List", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext:context)
        
        self.name = ""
        self.id = ""
        
    }

}

extension List{
    
    func addProduct(product : Product) {
        var items = self.mutableSetValueForKey("products");
        items.addObject(product);
    }
    
    func returnProduct() -> [Product] {
        var items = self.mutableSetValueForKey("products")
        var array = items.allObjects
        return array as! [Product]
    }
    
    func removeProduct(product : Product) {
        var items = self.mutableSetValueForKey("products")
        items.removeObject(product)
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

    func removeTag(tag : Tag) {
        var items = self.mutableSetValueForKey("tags")
        items.removeObject(tag)
    }
    
}

