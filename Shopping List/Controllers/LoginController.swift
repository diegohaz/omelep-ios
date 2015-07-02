//
//  Login.swift
//  Shopping List
//
//  Created by Bruno Baring on 5/29/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    static let sharedInstance = LoginController()
//    let loginView : FBSDKLoginButton = FBSDKLoginButton()
    var login: UIButton = UIButton()
    var botaoEntra: UIButton = UIButton()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {

        self.view.backgroundColor = UIColor.whiteColor()
        let background: UIImageView = UIImageView(frame: self.view.frame)
        background.image = UIImage(named: "screen")
        self.view.addSubview(background)
        
        NSUserDefaults.standardUserDefaults().setObject("Login", forKey: "Last Screen")
        
        activityIndicator.frame = CGRectMake(100, 100, 100, 100)
        self.view.addSubview(activityIndicator)
    
        
//        login.frame = CGRectMake(39, 443, 240, 44)
        login.frame.size.width = 240
        login.frame.size.height = 44
        login.frame.origin = CGPointMake((self.view.frame.width/2) - (login.frame.width/2), self.view.frame.height - 125)
        login.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        login.layer.cornerRadius = 22
        login.setTitle("Entrar com Facebook", forState: UIControlState.Normal)
        login.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        login.addTarget(self, action: "doLogin", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(login)
        
        botaoEntra.frame.size.width = 240
        botaoEntra.frame.size.height = 44
        botaoEntra.frame.origin = CGPointMake((self.view.frame.width/2) - (login.frame.width/2), self.view.frame.height - 50)
        botaoEntra.setTitle("Entrar sem login", forState: UIControlState.Normal)
        botaoEntra.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        botaoEntra.addTarget(self, action: "loginSemCadastro", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(botaoEntra)
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            println("user inicializou logado")
            let listsController: ListsController = ListsController()
            self.navigationController?.pushViewController(listsController, animated: true)
        }else{
            println("user inicializou DESLOGADO")
        }
        

    }
    
    func loginSemCadastro() {
        
        //Vendo se já logou ou não
        if( NSUserDefaults.standardUserDefaults().objectForKey("isLoggedIn") != nil ){
            
            //
            println("user inicializou logado")
            let listsController: ListsController = ListsController()
            self.navigationController?.pushViewController(listsController, animated: true)
            
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        trackScreen("Login")
    }
    
    func doLogin(){
        
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["email", "public_profile"]){ result, error in
            println("RESULT: '\(result)' ")
            
            if error != nil {
                println("error")
            }else if(result.isCancelled){
                println("usuario cancelou a autorizacao")
            }else{
                println("success Get user information.")
                
                var fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: nil);
                fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                    
                    if error == nil {
                        
                        println("User Info : \(result)")
                        
                        FunctionsFacebook.sharedInstance.registerUser(){ user in
                            
                            let listsController: ListsController = ListsController()
                            self.navigationController?.pushViewController(listsController, animated: true)
                            println("ja chegou a resposta")
                            self.activityIndicator.stopAnimating()
                            
                        }
                    } else {
                        
                        println("Error Getting Info \(error)");
                    }
                }
            }
        }

    }
    
    func startActivityIndicator(){
        activityIndicator.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}