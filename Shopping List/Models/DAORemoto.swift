//
//  DAO.swift
//  Shopping List
//
//  Created by Matheus Falcão on 25/05/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import Foundation

private let _dao = DAORemoto()

class DAORemoto {
    
    class var sharedInstance: DAORemoto {
        return _dao
    }
    
    private init() {
    }
    
    //Função para normalizar o nome de produtos, listas e tags para pesquisa
    private func normaliza(text : String) -> String {
        
        var ntext = text.stringByFoldingWithOptions(NSStringCompareOptions.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
        
        ntext = ntext.lowercaseString
        
        return ntext
        
    }
    
    //Lists:
    
    //Função que salva um nova lista:
    func saveNewList(list : List) -> List{
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
        var tags = []
        var products = []
        
        //TODO: Função para achar usuário
        var users = ["HKJKUYGKEU": true]
        
        var info = ["searchName": normaliza(list.name),"name": "\(list.name)", "products": products, "tags": tags, "users": users]

        var listRef = myRootRef.childByAppendingPath("list")
        
        //Gerando o ID e colocando na lista:
        var infoAdd = listRef.childByAutoId()
        list.id = infoAdd.key
        
        //Salvando a nova Lista no CoreData:
        DAOLocal.sharedInstance.save()
        
        //Salvando no FireBase:
        infoAdd.setValue(info)
        
        return list
        
    }
    
    //Products:
    
    //Função que salva um novo produto:
    func saveNewProduct(product : Product) -> Product{
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
        //TODO: Função para achar usuário
        var users = ["HKJKUYGKEU": true]
        
        var info = ["searchName": normaliza(product.name),"name": "\(product.name)", "brand": "\(product.brand)", "cubage": "\(product.cubage)"]
        
        var listRef = myRootRef.childByAppendingPath("product")
        
        //Gerando o ID e colocando na lista:
        var infoAdd = listRef.childByAutoId()
        product.id = infoAdd.key
        
        //Salvando a nova Lista no CoreData:
        DAOLocal.sharedInstance.save()
        
        //Salvando no FireBase:
        infoAdd.setValue(info)
        
        return product
        
    }
    
    //Função que procura produto a partir do nome:
    func searchProductFromName(name : String, callback: (Product) -> Void) {
        
        var product : Product = Product()
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
        var listRef = myRootRef.childByAppendingPath("product")
    
        listRef.queryOrderedByChild("searchName").queryEqualToValue(normaliza(name)).observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
        
            if( snapshot.exists() == true ) {
                var dic = snapshot.value as! NSDictionary
                var key = dic.allKeys[0] as! String
                product.name = dic[key]!.objectForKey("name")! as! String
                product.cubage = dic[key]!.objectForKey("cubage")! as! String
                product.brand = dic[key]!.objectForKey("brand")! as! String
                product.id = key
            } else {
                product.name = name
                product = self.saveNewProduct(product)
            }
            callback(product)
        })
    }
    
    //Função que procura produto a partir do ID:
    func searchProductFromID(id : String, callback: (Product) -> Void) {
        var product : Product = Product()
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/product/\(id)")
        
        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            if( snapshot.exists() == true ) {
                
            } else {
                
            }
            
        })
        
        
        return product
        
    }
    
    
//    //Função que procura uma lista a partir do ID
//    func searchListFromID(ID : String) -> [List] {
//        
//        
//        
//    }
    
    
    
    
    //        //Canectando ao FireBase:
    //        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
    //
    //        var tags = []
    //        var products = []
    //        var users = ["FRFRFRF": true]
    //
    //        var info = ["name": "Compras do mês", "products": products, "tags": tags, "users": users]
    //
    //        var usersRef = myRootRef.childByAppendingPath("list")
    //        //Colocando o ID:
    //        let post1Ref = usersRef.childByAutoId()
    //        post1Ref.setValue(info)
    
    //        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/")
    //        var chave : String = ""
    //
    //        var dic : NSDictionary = NSDictionary()
    
    //        //Pegando a chave
    //        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
    //            dic = snapshot.value as! NSDictionary
    //            chave = dic.allKeys[0] as! String
    //            print(chave)
    //        })
    
    //Pesquisa pro filtro
    //        myRootRef.queryOrderedByChild("name").queryEqualToValue("Mesa").observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
    //            var dic = snapshot.value as? NSDictionary
    //
    //            println(snapshot.value)
    //
    //        })
    
    //        //Adicionando um produto:
    //        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
    //            dic = snapshot.value as! NSDictionary
    //            chave = dic.allKeys[0] as! String
    //            var ref = myRootRef.childByAppendingPath("\(chave)/products")
    //            var products = ["BRIGADEIRO": true]
    //            ref.updateChildValues(products)
    //        })
    
    //        //Retirando um produto:
    //        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
    //            dic = snapshot.value as! NSDictionary
    //            chave = dic.allKeys[0] as! String
    //            var ref = myRootRef.childByAppendingPath("\(chave)/products/FREHVD")
    //            //var products = ["BRIGADEIRO": true]
    //            ref.removeValue()
    //
    //        })
    
    //        //Pesquisa por filtro palavra começa com C
    //        myRootRef.queryOrderedByChild("name").queryStartingAtValue("C").observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
    //            var dic = snapshot.value as? NSDictionary
    //            
    //            println(snapshot.value)
    //        
    //        })
    
    //MUITO IMPORTANTE:
    //        var p: Product! = nil
    //        DAORemoto.sharedInstance.searchProductFromName("Arroz") { product in
    //            p = product
    //            println(p)
    //        }

    
    
}