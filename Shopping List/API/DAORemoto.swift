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
    
    /**Função que salva um nova lista:*/
    func saveNewList(list : List) -> List{
        
        var user : User
        user = DAOLocal.sharedInstance.readUser()
        
        if( NetworkConnect.sharedInstance.connected() ) {
        
            var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
            var tags = []
            var products = []
            var users = []
        
            var info = ["searchName": FunctionsDAO.sharedInstance.normaliza(list.name),"name": "\(list.name)", "products": products, "tags": tags, "users": users]

            var listRef = myRootRef.childByAppendingPath("list")
        
            //Gerando o ID e colocando na lista:
            var infoAdd = listRef.childByAutoId()
            list.id = infoAdd.key
        
            //Salvando no FireBase:
            infoAdd.setValue(info, withCompletionBlock: { ((NSError!, Firebase!)) in
                //Fazendo relação lista - usuário no FireBase
                FunctionsDAO.sharedInstance.createRelationUserList(user, list:list)
            })
            
        }
        
        //Fazendo relação lista - usuário no CoreData
        DAOLocal.sharedInstance.relationUserList(user, list: list)
        
        //Salvando a nova Lista no CoreData:
        DAOLocal.sharedInstance.save()
        
        return list
        
    }
    
    
    /**Função que retorna todas as listas de um usuário:*/
    func allListOfUser(callback: [List] -> Void) {

        var user : User = DAOLocal.sharedInstance.readUser()
        
        var arrayList : [List] = user.returnList()
        
        var listsDeleted : [List] = DAOLocal.sharedInstance.returnDeletedLists()

        callback(arrayList)

        if( NetworkConnect.sharedInstance.connected() ) {
        
            var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/user/\(user.id)/lists")

            //Removendo observes antigos
            myRootRef.removeAllObservers()
            
            myRootRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot: FDataSnapshot!) -> Void in
                
                arrayList = user.returnList()

                var key = snapshot.key

                FunctionsDAO.sharedInstance.searchListFromID(key, callback: { (list : List) in
                    
                    var bool = true
                    for lis in arrayList {
                        if( lis.id == list.id ){
                            bool = false
                        }
                    }
                    for lis in listsDeleted {
                        if( lis.id == list.id ){
                            bool = false
                        }
                    }
                    if( bool ) {
                        arrayList.insert(list, atIndex: 0)
                        DAOLocal.sharedInstance.relationUserList(user, list: list)
                        DAOLocal.sharedInstance.save()
                        callback(arrayList)
                    }
                
                })
        
            })
        
            var myRootRef2 = Firebase(url:"https://luminous-heat-6986.firebaseio.com/user/\(user.id)/lists")
            
            myRootRef2.observeEventType(FEventType.ChildRemoved, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
                var key = snapshot.key

                var i = 0
                for x in arrayList {
                    if( x.id == key ){
                        break;
                    }
                    i++;
                }
                arrayList.removeAtIndex(i)
                callback(arrayList)
                
            })
        }
        
    }
    
    //TODO: Fazer essa função com a parte offline
    /**Funçao que adiciona produto em uma lista:*/
    func addProductToList(name : String, list : List) {
        
        list.updatedDate = NSDate()
        DAOLocal.sharedInstance.save()
        
        if( NetworkConnect.sharedInstance.connected() ) {
        
            FunctionsDAO.sharedInstance.searchProductFromName(name, callback: { (product : Product) in
                
                DAOLocal.sharedInstance.addProduct(product, list: list)
            
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
            
            })
            
        } else {
            
            var product : Product = DAOLocal.sharedInstance.searchProduct(name)
        
            DAOLocal.sharedInstance.addProduct(product, list: list)
            
        }
        
        
    }
    
    /**Função que deleta um produto de uma lista*/
    func deleteProductFromList(product : Product, list: List) {
        
        if( NetworkConnect.sharedInstance.connected() ) {
        
            FunctionsDAO.sharedInstance.searchProductFromName(product.name, callback: { products in
        
                var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(list.id)/products/\(products.id)")
            
                myRootRef.removeValue()
            
            })
        
        }
        
        list.removeProduct(product)
        list.updatedDate = NSDate()
        DAOLocal.sharedInstance.save()
        
    }
    
    /**Função que muda o nome de uma lista*/
    func changeNameOfList(name : String, list: List) {
        
        list.name = name
        list.updatedDate = NSDate()
        DAOLocal.sharedInstance.save()
     
        if( NetworkConnect.sharedInstance.connected() ){
            
            var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(list.id)")
        
            myRootRef.observeEventType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
                if( snapshot.exists() == true ){
                    var dic = snapshot.value as! NSDictionary
                
                    dic.setValue(name, forKey: "name")
                
                    myRootRef.setValue(dic)
                
                }
            
            })
            
        }
        
    }
    
    /**Função que deleta uma lista*/
    func deleteList(list : List){
        
        var user : User = DAOLocal.sharedInstance.readUser()
        user.removeList(list)
        list.removeUser(user)
        list.delete = true
        DAOLocal.sharedInstance.save()
        print("\n\n INICIO \n\n")
        print(user.returnList())
        
        if( NetworkConnect.sharedInstance.connected() ){
            
            var myUserRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/user/\(user.id)/lists/\(list.id)")
            
            myUserRef.removeValue()
            
        }
        
    }
    
    //TODO: Fazer função que exclui listas do fireBase que não tem usuário relacionado!!
    
    //Products:
    
    /**Função que salva um novo produto:*/
    func saveNewProduct(product : Product) -> Product{
        
        if( NetworkConnect.sharedInstance.connected() ) {
        
            var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
            var info = ["searchName": FunctionsDAO.sharedInstance.normaliza(product.name),"name": "\(product.name)", "brand": "\(product.brand)", "cubage": "\(product.cubage)"]
        
            var listRef = myRootRef.childByAppendingPath("product")
        
            //Gerando o ID e colocando na lista:
            var infoAdd = listRef.childByAutoId()
            product.id = infoAdd.key
        
            //Salvando no FireBase:
            infoAdd.setValue(info)
            
        }
        
        //Salvando o produto:
        DAOLocal.sharedInstance.save()
        
        return product
        
    }

    /**Função que retorna todos os produtos de uma lista, e isso inclui uma atualização quando tem mais de um usuário na mesma lista*/
    func allProductsOfList(list : List, callback: ([Product]) -> Void ) {
        
        var products : [Product] = list.returnProduct()
        
        callback(products)
        
        if( NetworkConnect.sharedInstance.connected() ) {
        
            var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(list.id)/products")
            
            //Removendo observers antigos:
            myRootRef.removeAllObservers()

            myRootRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot : FDataSnapshot!) -> Void in
            
                var key = snapshot.key
            
                FunctionsDAO.sharedInstance.searchProductFromID(key, callback: { (product : Product) -> Void in
                    var bool = true
                    for pro in  products {
                        if( pro.name == product.name ){
                            bool = false
                        }
                    }
                    if( bool ){
                        products.insert(product, atIndex: 0)
                        list.addProduct(product)
                        DAOLocal.sharedInstance.save()
                        callback(products)
                    }
            
                })
            
            })
        
            var myRootRef2 = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(list.id)/products")
        
            myRootRef2.observeEventType(FEventType.ChildRemoved, withBlock: { (snapshot : FDataSnapshot!) -> Void in
            
                var key = snapshot.key
            
                FunctionsDAO.sharedInstance.searchProductFromID(key, callback: { (product : Product) -> Void in
                    var i = 0
                    for x in products {
                        if( x.name == product.name ){
                            break;
                        }
                        i++;
                    }
                    products.removeAtIndex(i)
                    list.removeProduct(product)
                    DAOLocal.sharedInstance.save()
                    callback(products)
                })
            
            })
            
        }
        
    }
    
    //Relacão User e List
    
    /**Funcão que adiciona um amigo a uma lista*/
    func addFriendToList(idFB : String, list : List) {
        
        FunctionsDAO.sharedInstance.searchIDFromIDFB(idFB, callback: { (id : String) in
            
            var user : User = User()
            
            user.id = id
            
            FunctionsDAO.sharedInstance.createRelationUserList(user, list: list)
            
        })
        
    }
    
    //Suggestions:
    
    /**Função que retorna todas as listas de um usuário:*/
    func suggestionsLists(callback: [List] -> Void) {
        
        var arrayList : [List] = []
        
        if( NetworkConnect.sharedInstance.connected() ) {
        
            var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/suggestion")
        
            myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
                if( snapshot.exists() == true ){
                
                    var dic = snapshot.value as! NSDictionary
                
                    var keys = dic.allKeys
                    for x in keys {
                        FunctionsDAO.sharedInstance.searchListFromID(x as! String, callback:  { (lis : List) in
                                
                            arrayList.append(lis)
                                
                            if(keys.count == arrayList.count ){
                                callback(arrayList)
                            }
                                
                        })
                    
                    }
                
                }
            
            })
            
        }
        
    }
    
    
    //Sincronização Onlie - Offline
    
    func sincroniza() {
    
        if( NetworkConnect.sharedInstance.connected() ) {
        
            //Deletando listas que foram deletadas offline no FireBase
            FunctionsDAO.sharedInstance.sDeleteListOnFireBase()
            
            //Colocando online listas que foram criadas offline:
            FunctionsDAO.sharedInstance.sPutListsOnline()
            
            //Agora ajustando os produtos da lista:
            
            var user : User = DAOLocal.sharedInstance.readUser()
            
            var listsOff : [List] = user.returnList()
            
            var refList = Firebase(url:"https://luminous-heat-6986.firebaseio.com/user/\(user.id)/lists/")
            
            refList.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot : FDataSnapshot!) -> Void  in
                
                
                
            })
            
        
        }
        
    }
    
    
    
    
    
}