//
//  FunctionsDAO.swift
//  Shopping List
//
//  Created by Matheus Falcão on 30/05/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import Foundation

private let _dao = FunctionsDAO()

class FunctionsDAO {
    
    class var sharedInstance: FunctionsDAO {
        return _dao
    }
    
    private init() {
    }
    
    /**Função para normalizar o nome de produtos, listas e tags para a pesquisa*/
    func normaliza(text : String) -> String {
        
        var ntext = text.stringByFoldingWithOptions(NSStringCompareOptions.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
        
        ntext = ntext.lowercaseString
        
        return ntext
        
    }
    
    //Lists:
    
    //TODO: com tags essa função vai dar ruim!!!
    /**Função que procura lista a partir do ID:*/
    func searchListFromID(id : String, callback: (List) -> Void) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(id)")
        
        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            var list : List = List()
            
            if( snapshot.exists() == true ) {
                var dic = snapshot.value as! NSDictionary
                list.name = dic.objectForKey("name")! as! String
                list.id = id
                
                //Pegando os produtos de cada lista
                var keys = dic.allKeys
                for x in keys {
                    if x as! String == "products" {
                        var keysProducts = dic["products"]!.allKeys
                        
                        for keyP in keysProducts {
                            
                            self.searchProductFromID(keyP as! String, callback: { (pro : Product) in
                                
                                DAOLocal.sharedInstance.addProduct(pro, list: list)
                                
                                if( list.products.count == keysProducts.count ){
                                    callback(list)
                                }
                                
                            })
                            
                        }
                        
                    }
                }
                
                //Pegando as tags de cada lista
                keys = dic.allKeys
                for x in keys {
                    if x as! String == "tags" {
                        var keysProducts = dic["tags"]!.allKeys
                        
                        for keyP in keysProducts {
                            
                            self.searchTagFromID(keyP as! String, callback: { (ta : Tag) in
                                
                                DAOLocal.sharedInstance.addTag(ta, list: list)
                                
                                if( list.tags.count == keysProducts.count ){
                                    callback(list)
                                }
                                
                            })
                            
                        }
                        
                    }
                }
                
                
            } else {
                print("lista não encotrada! \n")
            }
            
        })
        
    }
    
    /**Funçao que adiciona uma lista para um usuário*/
    func addListToUser(list : List, user : User) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/user/\(user.id)")
        
        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            if( snapshot.exists() == true ){
                var refList = myRootRef.childByAppendingPath("lists")
                var lis = ["\(list.id)": true]
                refList.updateChildValues(lis)
            } else {
                print("Usuário não existe \n")
            }
            
        })
        
    }
    
    
    
    //Products:
    
    /**Função que procura produto a partir do ID:*/
    func searchProductFromID(id : String, callback: (Product) -> Void) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/product/\(id)")
        
        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            var product : Product = Product()
            
            if( snapshot.exists() == true ) {
                var dic = snapshot.value as! NSDictionary
                product.name = dic.objectForKey("name")! as! String
                product.cubage = dic.objectForKey("cubage")! as! String
                product.brand = dic.objectForKey("brand")! as! String
                product.id = id
            } else {
                print("produto não encotrado! \n")
            }
            callback(product)
        })
        
    }
    
    
    
    //Tags:
    /**Função que procura tag a partir do ID:*/
    func searchTagFromID(id : String, callback: (Tag) -> Void) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/product/\(id)")
        
        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            var tag : Tag = Tag()
            
            if( snapshot.exists() == true ) {
                var dic = snapshot.value as! NSDictionary
                tag.name = dic.objectForKey("name")! as! String
                tag.id = id
            } else {
                print("tag não encotrado! \n")
            }
            callback(tag)
        })
        
    }
    
    //Users:
    /**Funçao que adiciona um usuário para uma lista*/
    func addUserToList(user : User, list : List) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(list.id)")
        
        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            if( snapshot.exists() == true ){
                var refList = myRootRef.childByAppendingPath("users")
                var use = ["\(user.id)": true]
                refList.updateChildValues(use)
            } else {
                print("Lista não existe \n")
            }
            
        })
        
        
    }
    
    /**Função que procura ID do usuário a partir do IDFB*/
    func searchIDFromIDFB(user : User, callback: (String) -> Void) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
        var listRef = myRootRef.childByAppendingPath("user")
        
        listRef.queryOrderedByChild("idfb").queryEqualToValue(user.id).observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            if( snapshot.exists() == true ) {
                var dic = snapshot.value as! NSDictionary
                var chave = dic.allKeys[0] as! String
                callback(chave)
            } else {
                print("Usuário nao registrado, mas logado?? ")
            }
        })
        
    }
    
    
}