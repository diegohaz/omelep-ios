//
//  Tag.swift
//  
//
//  Created by Matheus Falcão on 25/05/15.
//
//

import Foundation
import CoreData
import UIKit

@objc(Tag)

class Tag: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var id: String
    
    convenience init() {
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context : NSManagedObjectContext
        context = appDelegate.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("Tag", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext:context)
        
    }
    

}


