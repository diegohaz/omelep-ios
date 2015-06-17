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

                        var user : User = User()
                        
                        user.name = name
                        user.id = id
                        
                        DAORemoto.sharedInstance.addFriendToUser(user)
                        
                    })
                    
                    i++
                }
                
            }
        
        
        }
        
    }
    
    
}
