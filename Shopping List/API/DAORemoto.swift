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
            var date = NSDate().description

            var info = ["searchName": FunctionsDAO.sharedInstance.normaliza(list.name),"name": "\(list.name)", "products": products, "tags": tags, "users": users, "date": date]

            var listRef = myRootRef.childByAppendingPath("list")

            //Gerando o ID e colocando na lista:
            var infoAdd = listRef.childByAutoId()

            list.id = infoAdd.key

            DAOLocal.sharedInstance.save()

            //Salvando no FireBase:
            infoAdd.setValue(info, withCompletionBlock: { ((NSError?, Firebase?)) in
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
    
    /**Funçao que adiciona produto em uma lista:*/
    func addProductToList(name : String, list : List) {
        
        list.updatedDate = NSDate()
        
        if( NetworkConnect.sharedInstance.connected() ) {
        
            FunctionsDAO.sharedInstance.searchProductFromName(name, callback: { (product : Product) in
                
                DAOLocal.sharedInstance.addProduct(product, list: list)
                DAOLocal.sharedInstance.save()
            
                var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(list.id)")
            
                myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
                
                    if( snapshot.exists() == true ){
                        var refProd = myRootRef.childByAppendingPath("products")
                        var refDate = myRootRef.childByAppendingPath("date")
                        var prod = ["\(product.id)": true]
                        refProd.updateChildValues(prod)
                        refDate.setValue(NSDate().description)
                    } else {
                        print("lista não existe \n")
                    }
                
                })
                
            
            })
            
        } else {
            
            var product : Product = DAOLocal.sharedInstance.searchProduct(name)
        
            DAOLocal.sharedInstance.addProduct(product, list: list)
            DAOLocal.sharedInstance.save()
            
        }
        
        
    }
    
    /**Função que deleta um produto de uma lista*/
    func deleteProductFromList(product : Product, list: List) {
        
        if( NetworkConnect.sharedInstance.connected() ) {
        
            FunctionsDAO.sharedInstance.searchProductFromName(product.name, callback: { products in
        
                var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(list.id)/products/\(products.id)")
            
                myRootRef.removeValue()
                
                //Atualizando a data da última modificação:
                var myRoot2 = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(list.id)")
                
                myRoot2.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
                    
                    if( snapshot.exists() == true ){
                        var refDate = myRoot2.childByAppendingPath("date")
                        refDate.setValue(NSDate().description)
                    } else {
                        print("lista não existe \n")
                    }
                    
                })
            
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
                    
                    //Atualizando a data da última modificação:
                    var refDate = myRootRef.childByAppendingPath("date")
                    refDate.setValue(NSDate().description)
                
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
                
                products = list.returnProduct()
            
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
        
            var myRootRef2 = Firebase(url:"https://luminous-heat-6986.firebaseio.com/|list/\(list.id)/products")
        
            myRootRef2.observeEventType(FEventType.ChildRemoved, withBlock: { (snapshot : FDataSnapshot!) -> Void in
            
                var key = snapshot.key
                
                products = list.returnProduct()
            
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
    
    /**Funcão que remove um amigo a uma lista*/
    func removeFriendToList(idFB : String, list : List) {
        
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
    
    func sincroniza(callback: [List] -> Void) {
    
        if( NetworkConnect.sharedInstance.connected() ) {
            
            var user : User = DAOLocal.sharedInstance.readUser()
        
            //Deletando listas que foram deletadas offline no FireBase
            FunctionsDAO.sharedInstance.sDeleteListOnFireBase()
            
            //Colocando online listas que foram criadas offline:
            FunctionsDAO.sharedInstance.sPutListsOnline()
            
            //Agora ajustando os produtos da lista:
            FunctionsDAO.sharedInstance.sAllListsOnlineAndOffilne({ (listsON : [List], listsOFF : [List]) -> Void in

                //Ajustando os produtos
                for lists1 : List in listsON {
                    for lists2 : List in listsOFF {
                        if( lists1.id == lists2.id ) {
                            
                            if( lists1.updatedDate == lists1.updatedDate.earlierDate(lists2.updatedDate) ){
                                
                                //Lista 2 ta mais atualizada
                                var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(lists2.id)")
                                
                                var users = []
                                var date = NSDate().description
                                var tags = []
                                var products : NSDictionary = NSDictionary()
                                var allProducts = lists2.returnProduct()
                                
                                for product in allProducts{
                                    
                                    FunctionsDAO.sharedInstance.searchProductFromName(product.name, callback: { (newProduct) -> Void in
                                        products.setValue(true, forKey: newProduct.id)
                                        product
                                        
                                        if( product == allProducts.last ){
                                            
                                            var info = ["searchName": FunctionsDAO.sharedInstance.normaliza(lists2.name),"name": "\(lists2.name)", "products": products, "tags": tags, "users": users, "date": date]

                                            myRootRef.setValue(info)

                                            callback(user.returnList())

                                        }
                                        
                                    })
                                    
                                }
                                
                                
                            } else {
                                
                                var id : String = lists1.id
                                
                                DAOLocal.sharedInstance.deleteList(lists1)
                                
                                FunctionsDAO.sharedInstance.searchListFromID(id, callback: { (newList) -> Void in
                                    
                                    DAOLocal.sharedInstance.relationUserList(user, list: newList)
                                    
                                    callback(user.returnList())
                                    
                                })
                                
                            }
                            
                        }
                    }
                }
 
 
                //Deletando listas, que foram deletadas no firebase mas não no CoreData:
                for lists3 : List in listsOFF {
                    
                    if( lists3.id.isEmpty == false ){
                        var myReef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/user/\(user.id)/lists/\(lists3.id)")
                        
                        myReef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot : FDataSnapshot!) -> Void in

                            if( snapshot.exists() == false ){
                                user.removeList(lists3)
                                DAOLocal.sharedInstance.save()
                                
                            }
                            
                            if( lists3 == listsOFF.last ){
                                callback(user.returnList())
                            }
                            
                        })
                    }
                    
                }
                
            })
            
        
        }
        
        
    }
    
    
    //Users:
    
    /**Função que adiciona um amigo a um usuário*/
    func addFriendToUser(user : User) {
        
        var thisUser : User = DAOLocal.sharedInstance.readUser()
        
        thisUser.addUser(user)
        DAOLocal.sharedInstance.save()
        
        if( NetworkConnect.sharedInstance.connected() ) {
        
            var myRef = Firebase(url: "https://luminous-heat-6986.firebaseio.com/user/\(thisUser.id)/")
            
            myRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot : FDataSnapshot!) -> Void in
                
                if( snapshot.exists() == true ) {
                    
                    var refUser = myRef.childByAppendingPath("users")
                    
                    var usr = ["\(user.id)": true]
                    
                    refUser.updateChildValues(usr)
                    
                } else {
                    
                    print("Usuário não encontrado \n")
                }
                
            })
            
        }
        
        
    }
    
    /**Função que deleta um amigo de um usuário*/
    func removeFriendToUser(user : User) {
        
        var thisUser : User = DAOLocal.sharedInstance.readUser()
        
        thisUser.removeUser(user)
        DAOLocal.sharedInstance.save()
        
        if( NetworkConnect.sharedInstance.connected() ) {
            
            var myRef = Firebase(url: "https://luminous-heat-6986.firebaseio.com/user/\(thisUser.id)/users/\(user.id)")
            
            myRef.removeValue()
            
        }
        
    }
    
    /**Função que retorna todos os amigos do usuário logado*/
    func allFriends() -> [User] {
        
        var user : User = DAOLocal.sharedInstance.readUser()
        
        return user.returnUser()
        
    }
    
    
    
    
}