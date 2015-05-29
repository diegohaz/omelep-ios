//
//  Login.swift
//  Shopping List
//
//  Created by Bruno Baring on 5/29/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class LoginController: UIViewController, FBSDKLoginButtonDelegate {
    
    static let sharedInstance = LoginController()
    let loginView : FBSDKLoginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.greenColor()
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
//            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            self.navigationController?.pushViewController(ListsController.sharedInstance, animated: false)
            
            println("user inicializou logado")
            
            
        }
        else
        {
//            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            println("user inicializou DESLOGADO")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerUser( callback: (User) -> Void) {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error (NO LOGIN DO FACEBOOK): \(error)")
            }
            else
            {
                //verifica se usuario ja existe
                var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
                
                var listRef = myRootRef.childByAppendingPath("user")
                
                listRef.queryOrderedByChild("idfb").queryEqualToValue(result.valueForKey("id")).observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
                    
                    var user : User = User()
                    
                    if( snapshot.exists() == true ) {
                        var dic = snapshot.value as! NSDictionary
                        var key = dic.allKeys[0] as! String
                        user.id = dic[key]!.objectForKey("idfb")! as! String
                        println("User Registrado")
                    } else {
                        println("User não encontrado. Tem q registrar!")
                        println("fetched user: \(result)")
                        let userName : NSString = result.valueForKey("name") as! NSString
                        println("User Name is: \(userName)")
                        let userEmail : NSString = result.valueForKey("email") as! NSString
                        println("User Email is: \(userEmail)")
                        
                        var info = ["idfb": result.valueForKey("id") as! String , "email": result.valueForKey("email") as! String, "gender": result.valueForKey("gender") as! String, "locale": result.valueForKey("locale") as! String, "name": result.valueForKey("name") as! String,  /* "timezone": result.valueForKey("timezone") as! String, */ "updated_time": result.valueForKey("updated_time") as! String, "verified": result.valueForKey("verified") as! Bool, "access_token": FBSDKAccessToken.currentAccessToken().tokenString ]
                        
                        //                var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
                        
                        var userRef = myRootRef.childByAppendingPath("user")
                        var infoAdd = userRef.childByAutoId()
                        infoAdd.setValue(info)
                        
                        
                        callback(user)
                    }
                })
            }
        })
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        registerUser(){ user in
            
            self.navigationController?.pushViewController(ListsController.sharedInstance, animated: false)
            
        }
        
        
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User Email is: \(userEmail)")
            }
        })
    }
}
