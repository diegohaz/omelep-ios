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
    
    //Lists:
    
    //Função que salva um nova lista:
    func saveNewList(list : List) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
        var tags = []
        var products = []
        
        //TODO: Função para achar usuário
        var users = ["HKJKUYGKEU": true]
        
        var info = ["name": "\(list.name)", "products": products, "tags": tags, "users": users]

        var listRef = myRootRef.childByAppendingPath("list")
        
        //Gerando o ID e colocando na lista:
        var infoAdd = listRef.childByAutoId()
        list.id = infoAdd.key
        
        //Salvando a nova Lista no CoreData:
        DAOLocal.sharedInstance.save()
        
        //Salvando no FireBase:
        infoAdd.setValue(info)
        
    }
    
    //Products:
    
    //Função que salva um novo produto:
    func saveNewProduct(product : Product) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
        //TODO: Função para achar usuário
        var users = ["HKJKUYGKEU": true]
        
        var info = ["name": "\(product.name)", "brand": "\(product.brand)", "cubage": "\(product.cubage)"]
        
        var listRef = myRootRef.childByAppendingPath("product")
        
        //Gerando o ID e colocando na lista:
        var infoAdd = listRef.childByAutoId()
        product.id = infoAdd.key
        
        //Salvando a nova Lista no CoreData:
        DAOLocal.sharedInstance.save()
        
        //Salvando no FireBase:
        infoAdd.setValue(info)
        
    }
    
    //Função que procura produto a partir do nome:
    func searchProduct(name : String) -> Product{
        
        var product : Product = Product()
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
    myRootRef.queryOrderedByChild("name").queryEqualToValue(name).observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
        
        if( snapshot.value.exists() == false ) {
            print("vazio")
        } else {
            print("Tem resultado")
        }
            //var dic = snapshot.value as! NSDictionary
            //var key = dic.allKeys[0] as! String
            //print(key)
            //print(produc)
        
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

    
    
}