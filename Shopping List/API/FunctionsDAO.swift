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
                
                var dateFormat = NSDateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                list.updatedDate = dateFormat.dateFromString(dic.objectForKey("date") as! String)!
                
                var entrou = false
                
                //Pegando os produtos de cada lista
                var keys = dic.allKeys
                for x in keys {
                    if x as! String == "products" {
                        entrou = true
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
                        entrou = true
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
                
                if(!entrou){
                    callback(list)
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
    
    /**Função que remove uma lista de um usuário*/
    func removeListFromUser(list : List, user : User) {
        
        //No CoreData
        list.removeUser(user)
        
        //No FireBase:
        
        if( NetworkConnect.sharedInstance.connected() ) {
        
            var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/user/\(user.id)/lists/\(list.id)")
        
            myRootRef.removeValue()
            
        }
        
    }
    
    /** Função que conta o número de usuários de uma lista */
    func allIdOfUsersOfList(list : List, callback: ([String]) -> Void ){
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(list.id)/users")
        
        myRootRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot : FDataSnapshot!) in
            var idUsers : [String] = []
            
            if(snapshot.exists()) {
                var dic = snapshot.value as! NSDictionary
                idUsers = dic.allKeys as! [String]
            }
            
            callback(idUsers)
            
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
    
    /**Função que procura produto a partir do nome:*/
    func searchProductFromName(name : String, callback: (Product) -> Void) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
        var listRef = myRootRef.childByAppendingPath("product")
        
        listRef.queryOrderedByChild("searchName").queryEqualToValue(FunctionsDAO.sharedInstance.normaliza(name)).observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
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
                product = DAORemoto.sharedInstance.saveNewProduct(product)
            }
            callback(product)
        })
    }
    
    
    
    //Tags:
    
    /**Função que procura tag a partir do ID:*/
    func searchTagFromID(id : String, callback: (Tag) -> Void) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/tag/\(id)")
        
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
        
        //Adicionando no CoreData:
        list.addUser(user)
        DAOLocal.sharedInstance.save()
        
        //Adicionando no FireBase
        if( NetworkConnect.sharedInstance.connected() ) {
        
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
        
    }
    
    /**Função que remove um usuário de uma lista*/
    func removeUserFromList(user : User, list : List) {
        
        //No Core Data
        user.removeList(list)
        
        //No FireBase:
        
        if( NetworkConnect.sharedInstance.connected() ) {
        
            var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/list/\(list.id)/users/\(user.id)")
        
            myRootRef.removeValue()
            
        }
        
    }
    
    /**Função que procura ID do usuário a partir do IDFB*/
    func searchIDFromIDFB(idfb : String, callback: (String) -> Void) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
        var listRef = myRootRef.childByAppendingPath("user")
        
        listRef.queryOrderedByChild("idfb").queryEqualToValue(idfb).observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            if( snapshot.exists() == true ) {
                var dic = snapshot.value as! NSDictionary
                var chave = dic.allKeys[0] as! String
                callback(chave)
            } else {
                print("Usuário nao registrado, mas logado?? \n")
            }
            
        })
        
    }
    
    /**Função que baixa a imagem a partir de um ID de um usuário*/
    func donwloadImageFromID(id : String, callback: (UIImage) -> Void) {
    
        var myRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/user/\(id)/photo")
        
        myRef.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot) -> Void in
            
            if( snapshot.exists() ){
                
                let strUrl = snapshot.value as! String
                let url = NSURL(string: strUrl)
                let imageData = NSData(contentsOfURL: url!)
                var image = UIImage(data: imageData!)!
                callback(image)
                
            } else {
                //TODO: Função que
            }
            
        })
    
    }
    
    
    //Suggestions:
    
    /** Função que adiciona uma lista para sugestão */
    func addListToSeggestion(list : List) {
        
        var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
        
        var seggestRef = myRootRef.childByAppendingPath("suggestion")
        
        var info = [list.id: true]
        
        //Salvando no FireBase:
        seggestRef.updateChildValues(info)
        
    }
    
    
    //Sincronização Onlie - Offline
    
    func sDeleteListOnFireBase() {
        
        var lists : [List] = DAOLocal.sharedInstance.returnDeletedLists()
        
        var user : User = DAOLocal.sharedInstance.readUser()
        
        for list in lists {
            
            if( list.id.isEmpty == false ){
                
                var myUserRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/user/\(user.id)/lists/\(list.id)")
                
                myUserRef.removeValue()
                
            }
            
        }
        
    }
    
    func sPutListsOnline() {
        
        var user : User = DAOLocal.sharedInstance.readUser()
        
        var lists : [List] = user.returnList()
        
        for list in lists {

            if( list.id.isEmpty == true ){
                
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
                
                //Salvando no FireBase:
                infoAdd.setValue(info, withCompletionBlock: { ((NSError!, Firebase!)) in
                    //Fazendo relação lista - usuário no FireBase
                    DAORemoto.sharedInstance.createRelationUserList(user, list:list)
                    
                    var arrayP = list.returnProduct()
                    
                    for product in  arrayP {
                        DAORemoto.sharedInstance.addProductToList(product.name, list: list)
                    }
                    
                })
                
            }
            
        }
        
    }
    
    /** Função que retorna todas as listas que estão online e offline do usuário */
    func sAllListsOnlineAndOffilne(callback: ([List], [List]) -> Void) {
        
        var user : User = DAOLocal.sharedInstance.readUser()
        
        var listsOFF : [List] = user.returnList()
        
        var listsON : [List] = []
        
        var allKeysOfLists : [String] = []
        
        var refList = Firebase(url:"https://luminous-heat-6986.firebaseio.com/user/\(user.id)/")
        
        refList.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot : FDataSnapshot!) -> Void  in

            if( snapshot.exists() ){
                var dic = snapshot.value as! NSDictionary
                
                var allKeys = dic.allKeys as! [String]
                
                for key in allKeys{
                    
                    if (key == "lists"){
                        allKeysOfLists = dic.objectForKey("lists")!.allKeys as! [String]
                    }
                    
                }
                
                //Agora "Carregando" cada lista:
                for keyOfList in allKeysOfLists {
                    FunctionsDAO.sharedInstance.searchListFromID(keyOfList, callback: { (list : List) -> Void in
                        
                        listsON.append(list)
                        
                        if( listsON.count == allKeysOfLists.count ){
                            callback(listsON, listsOFF)
                        }
                        
                    })
                }
                
                
            }
            
        })

        
    }
    
    
    
    
    
    
    
    
}