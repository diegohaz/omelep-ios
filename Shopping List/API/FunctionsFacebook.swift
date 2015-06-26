//
//  FunctionsFacebook.swift
//  Shopping List
//
//  Created by Matheus Falcão on 17/06/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import Foundation

private let _dao = FunctionsFacebook()

class FunctionsFacebook {
    
    class var sharedInstance: FunctionsFacebook {
        return _dao
    }
    
    private init() {
    }
    
    /**Função que regisra o usuário ou oega as informações dele no FireBase*/
    func registerUser( callback: (User) -> Void) {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        let graphRequestForImage : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/picture?redirect=false", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error)  in
            
            print("") //    NÃO APAGAR ESSE PRINT, SE NÃO DA MERDA
            
            graphRequestForImage.startWithCompletionHandler({ (connection2 : FBSDKGraphRequestConnection!, result2 : AnyObject!, error2 : NSError!) in
                
                if (((error) != nil) /*&& ((error2) != nil)*/)
                {
                    // Process error
                    println("Error (NO LOGIN DO FACEBOOK): \(error)")
                    println("Usuario não autorizou o Facebook")
                }
                else
                {
                    //verifica se usuario ja existe
                    var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
                    
                    var listRef = myRootRef.childByAppendingPath("user")
                    
                    listRef.queryOrderedByChild("idfb").queryEqualToValue(result.valueForKey("id")).observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
                        
                        //TODO: as vezes a pessoa desloga e loga com o msm usuário, não vai ser necessário apagar
                        
                        //Apagando dados do último usuário logado:
                        DAOLocal.sharedInstance.deleteAllUsers()
                        
                        //Deletando todas as listas salvas no celulat
                        DAOLocal.sharedInstance.deleteAllLists()
                        
                        var user : User = User()
                        
                        if( snapshot.exists() == true ) {
                            var dic = snapshot.value as! NSDictionary
                            var key = dic.allKeys[0] as! String
                            
                            //Salvando dados do usuário logado:
                            user.id = key
                            user.name = dic[key]!.objectForKey("name")! as! String
                            user.email = dic[key]!.objectForKey("email")! as! String
                            user.me = true
                            DAOLocal.sharedInstance.save()
                            
                            //Donwload da foto do usuário:
                            let url = NSURL(string: dic[key]!.objectForKey("photo")! as! String)
                            let imageData = NSData(contentsOfURL: url!)
                            var image : UIImage = UIImage(data: imageData!)!
                            DAOLocal.sharedInstance.saveImageOfUser(image, user: DAOLocal.sharedInstance.readUser())
                            
                            //Pegando os amigos do Facebook e fazendo download das fotos:
                            FunctionsFacebook.sharedInstance.getFacebookFriendsFromUser()
                            
                            println("User ja estava Registrado")
                            
                            
                        }
                        else {
                            
                            //Carregando a imagem:
                            let data: AnyObject? = result2.valueForKey("data")
                            let url = NSURL(string: data!.valueForKey("url") as! String)
                            
                            println("User não encontrado. Tem q registrar!")
                            let userName : NSString = result.valueForKey("name") as! NSString
                            println("User Name is: \(userName)")
                            
                            
                            var info = ["idfb": result.valueForKey("id") as! String, "photo": data!.valueForKey("url") as! String, "email": result.valueForKey("email") as! String, "gender": result.valueForKey("gender") as! String, "locale": result.valueForKey("locale") as! String, "name": result.valueForKey("name") as! String,  /* "timezone": result.valueForKey("timezone") as! String, */ "updated_time": result.valueForKey("updated_time") as! String, "verified": result.valueForKey("verified") as! Bool, "access_token": FBSDKAccessToken.currentAccessToken().tokenString]
                            
                            var userRef = myRootRef.childByAppendingPath("user")
                            
                            //Criando uma ID
                            var infoAdd = userRef.childByAutoId()
                            infoAdd.setValue(info)
                            
                            //Salvando dados do usuário logado:
                            user.id = infoAdd.key
                            user.name = result.valueForKey("name")! as! String
                            user.email = result.valueForKey("email")! as! String
                            user.me = true
                            DAOLocal.sharedInstance.save()
                            
                            ///Salvando a imagem
                            let imageData = NSData(contentsOfURL: url!)
                            var image : UIImage = UIImage(data: imageData!)!
                            DAOLocal.sharedInstance.saveImageOfUser(image, user: DAOLocal.sharedInstance.readUser())
                            
                            //Pegando os amigos do Facebook e fazendo download das fotos:
                            FunctionsFacebook.sharedInstance.getFacebookFriendsFromUser()
                            
                            
                        }
                        callback(user)
                        
                    })
                }
            })
        })
    }

    
    
    /**Função que pega todos amigos do facebook*/
    func getFacebookFriendsFromUser() {

        let friendRequest : FBSDKGraphRequest
        friendRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil, HTTPMethod: "GET")
        
        friendRequest.startWithCompletionHandler { (connection, result, error) -> Void in

            if( error != nil ){
                print("Erro ao pegar os amigos do facebook \n")
                print("Erro: \(error) \n")
            } else {

                let friends : AnyObject? = result.valueForKey("data")
                let friendNames: [String] = friends?.valueForKey("name") as! [String]
                let friendIDs: [String] = friends?.valueForKey("id") as! [String]

                var i = 0
                for name in friendNames{
                    //Pegando o ID do Firebase a partir do ID do facebook
                    FunctionsDAO.sharedInstance.searchIDFromIDFB(friendIDs[i], callback: { (id) -> Void in
                        
                        var entrou = false
                        
                        for udr in DAOLocal.sharedInstance.readUser().returnUser(){
                            if udr.id == id{
                                entrou = true
                            }
                        }
                        
                        if entrou == false {
                            
                            var user : User = User()
                            
                            user.name = name
                            user.id = id
                            
                            FunctionsDAO.sharedInstance.donwloadImageFromID(id, callback: { (image) -> Void in
                                DAOLocal.sharedInstance.saveImageOfUser(image, user: user)
                                DAORemoto.sharedInstance.addFriendToUser(user)
                            })
                            
                        }
                        
                    })
                    
                    i++
                }
                
            }
        
        
        }
        
    }
    
    
}
