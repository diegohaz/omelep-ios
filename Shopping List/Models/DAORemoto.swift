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
        
        //TODO: Adicionar essa lista ao usuário logado
        
        return list
        
    }
    
    //Função que retorna todas as listas de um usuário:
    func allListOfUser(user : User, callback: ([List]) -> Void) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/user/\(user.id)")
        
        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            if( snapshot.exists() == true ){
                
                
                
            }
            
        })
        
    }
    
    //Função que procura lista a partir do ID:
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
                            
                            //TODO: função searchTagFromId
//                            self.searchProductFromID(keyP as! String, callback: { (pro : Product) in
//                                
//                                DAOLocal.sharedInstance.addProduct(pro, list: list)
//                                
//                                if( list.products.count == keysProducts.count ){
//                                    callback(list)
//                                }
//                                
//                            })
                            
                        }
                        
                    }
                }
                
                
            } else {
                print("lista não encotrada! \n")
            }
            
        })
        
        
    }
    
    
    
    //Funçao que adiciona produto na lista:
    func addProductToList(product : Product, list : List) -> List {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(list.id)")
        
        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
        
            if( snapshot.exists() == true ){
                var refProd = myRootRef.childByAppendingPath("products")
                var prod = ["\(product.id)": true]
                refProd.updateChildValues(prod)
            } else {
                print("lista não existe \n")
            }
            
        })
        
        return DAOLocal.sharedInstance.addProduct(product, list: list)
        
    }
    
    //Funçao que adiciona lista para um usuário
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
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
        var listRef = myRootRef.childByAppendingPath("product")
    
        listRef.queryOrderedByChild("searchName").queryEqualToValue(normaliza(name)).observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            var product : Product = Product()
        
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