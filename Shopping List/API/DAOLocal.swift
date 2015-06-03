//
//  DAOLocal.swift
//  Shopping List
//
//  Created by Matheus Falcão on 25/05/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DAOLocal {
    
    static let sharedInstance = DAOLocal()
    
    private init() {
    }
    
    func save() {
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = NSManagedObjectContext()
        context = appDelegate.managedObjectContext!
        
        var erro : NSError?
        
        context.save(&erro)
        
    }
    
    //Users:
    func readUser() -> User {
     
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context : NSManagedObjectContext
        context = appDelegate.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
        
        var request : NSFetchRequest = NSFetchRequest()
        request.entity = entity
        
        var arguments:NSArray = [true]
        var pred : NSPredicate = NSPredicate(format: "(me == %@)", argumentArray: arguments as [AnyObject])
        request.predicate = pred
        
        var user : User
        var error : NSError?
        var result : NSArray = context.executeFetchRequest(request, error:&error)!
        
        user = result[0] as! User
        
        return user
        
    }
    
    
    func deleteAllUsers() {
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context : NSManagedObjectContext
        context = appDelegate.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
        
        var request : NSFetchRequest = NSFetchRequest()
        request.entity = entity
        
        var user : NSManagedObject
        var error : NSError?
        var result : NSArray = context.executeFetchRequest(request, error:&error)!
        
        for user in result {
            context.deleteObject(user as! NSManagedObject)
        }
        
        context.save(&error)
    }
    
    func cleanUsers() {
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context : NSManagedObjectContext
        context = appDelegate.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
        
        var request : NSFetchRequest = NSFetchRequest()
        request.entity = entity
        
        var user : NSManagedObject
        var error : NSError?
        var result : [User] = context.executeFetchRequest(request, error:&error)! as! [User]
        
        var userCerto : User = self.readUser()
        
        for user in result {
            if ( user != userCerto ) {
                context.deleteObject(user)
                print("User desnecessário deletado! \n")
            }
        }
        
        context.save(&error)
        
    }
    
    //Lists:
    
    func readLists() -> [List]{
        //TODO: descobrir usuário
        var user : User = User()
        return user.returnList()
        
    }
    
    func addProductFromName(productname : String, list : List) -> List{
        
        var product : Product = searchProduct(productname)
        
        list.addProduct(product)
        
        save()
        
        return list
        
    }
    
    func addProduct(product : Product, list : List) -> List{
        
        list.addProduct(product)
        
        save()
        
        return list
        
    }
    
    func removeProduct(product : Product, list : List) -> List{
        
        list.removeProduct(product)
        
        save()
        
        return list
        
    }
    
    func readProductFromList(list : List) -> [Product]{
     
        return list.returnProduct()
        
    }
    
    func deleteList(list : List) -> [List]{
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context : NSManagedObjectContext
        context = appDelegate.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("List", inManagedObjectContext: context)!
        
        var request : NSFetchRequest = NSFetchRequest()
        request.entity = entity
        
        var arguments:NSArray = ["\(list.id)"]
        var pred : NSPredicate = NSPredicate(format: "(id == %@)", argumentArray: arguments as [AnyObject])
        request.predicate = pred
        
        var lista : NSManagedObject
        var error : NSError?
        var result : NSArray = context.executeFetchRequest(request, error:&error)!
        
        lista = result[0] as! NSManagedObject
        
        context.deleteObject(lista)
        
        context.save(&error)
        
        return readLists()
        
    }
    
    //Products:
    
    private func searchProduct(productName : String) -> Product {
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context : NSManagedObjectContext
        context = appDelegate.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("Product", inManagedObjectContext: context)!
        
        var request : NSFetchRequest = NSFetchRequest()
        request.entity = entity
        
        var arguments:NSArray = ["\(productName)"]
        var pred : NSPredicate = NSPredicate(format: "(name == %@)", argumentArray: arguments as [AnyObject])
        request.predicate = pred
        
        var product : Product
        var error : NSError?
        var result : NSArray = context.executeFetchRequest(request, error:&error)!
        
        if( result.count > 0 ) {
            product = result[0] as! Product
        } else {
            product = Product()
            product.name = productName
        }

        return product
        
    }
    
    //Tags:
    func addTag(tag : Tag, list : List) -> List{
        
        list.addTag(tag)
        
        save()
        
        return list
        
    }
    
    func removeTag(tag : Tag, list : List) -> List{
        
        list.removeTag(tag)
        
        save()
        
        return list
        
    }
    
    func readTagFromList(list : List) -> [Tag]{
        
        return list.returnTags()
        
    }
    
    
    
    
}