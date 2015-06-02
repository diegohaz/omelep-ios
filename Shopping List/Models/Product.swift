//
//  Product.swift
//  
//
//  Created by Matheus Falcão on 25/05/15.
//
//

import Foundation
import CoreData
import UIKit

@objc(Product)

class Product: NSManagedObject {
    
    @NSManaged var brand: String
    @NSManaged var cubage: String
    @NSManaged var id: String
    @NSManaged var localID: NSNumber
    @NSManaged var name: String
    @NSManaged var photo: NSData
    @NSManaged var quantity: NSNumber
    
    convenience init() {
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context : NSManagedObjectContext
        context = appDelegate.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("Product", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext:context)
        
        self.cubage = ""
        self.brand = ""
        self.name = ""
        
    }

}

