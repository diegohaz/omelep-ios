//
//  Settings.swift
//  Shopping List
//
//  Created by Bruno Baring on 5/30/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit


class Settings: UIViewController,FBSDKLoginButtonDelegate {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        println("passou no settings controller")
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        loginView.frame.origin.x = 40
        loginView.center.y = self.view.center.y
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            //            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            //            self.navigationController?.pushViewController(ListsController.sharedInstance, animated: false)
            
            println("user inicializou logado")
            
            
        }
        else
        {
            //            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            println("user inicializou DESLOGADO")
            
        }
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        //        registerUser(){ user in
        //
        //            self.navigationController?.pushViewController(ListsController.sharedInstance, animated: false)
        //
        //        }
        
        
        
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
        let vc = LoginController()
        self.presentViewController(vc, animated: true, completion: nil)
        
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