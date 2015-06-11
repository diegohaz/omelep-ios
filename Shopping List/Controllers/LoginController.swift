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
    var login: UIButton = UIButton(frame: CGRectMake(39, 443, 240, 44))
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        let background: UIImageView = UIImageView(frame: self.view.frame)
        background.image = UIImage(named: "Login_background.png")
        self.view.addSubview(background)
        
        activityIndicator.frame = CGRectMake(100, 100, 100, 100)
        self.view.addSubview(activityIndicator)
        
        //        activityIndicator.stopAnimating()
        //        activityIndicator.startAnimating()
        //        activityIndicator.hidden = false
        //        activityIndicator.stopAnimating()
        
        //        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        
        login.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        login.layer.cornerRadius = 22
        login.setTitle("Entrar com Facebook", forState: UIControlState.Normal)
        login.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.view.addSubview(login)
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            println("user inicializou logado")
            
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            
            
            let listsController: ListsController = ListsController()
            self.navigationController?.pushViewController(listsController, animated: true)
        }
        else
        {
            
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            loginView.addTarget(self, action: "startActivityIndicator", forControlEvents: UIControlEvents.TouchUpInside)
            
            println("user inicializou DESLOGADO")
            
        }
    }
    
    func startActivityIndicator(){
        activityIndicator.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerUser( callback: (User) -> Void) {
        
        
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        let graphRequestForImage : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/picture?redirect=false", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error)  in
            print("")
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
                            println("User ja estava Registrado")
                            
                            
                        }
                        else {
                            ///imagem
                            let data: AnyObject? = result2.valueForKey("data")
                            let url = NSURL(string: data!.valueForKey("url") as! String)
                            let imageData = NSData(contentsOfURL: url!)
                            var image : UIImage = UIImage(data: imageData!)!
                            ///chamar a funcao aqui insere imagem no usuario
                            
                            println("User não encontrado. Tem q registrar!")
                            println("fetched user: \(result)")
                            let userName : NSString = result.valueForKey("name") as! NSString
                            println("User Name is: \(userName)")
                            let userEmail : NSString = result.valueForKey("email") as! NSString
                            println("User Email is: \(userEmail)")
                            var info = ["idfb": result.valueForKey("id") as! String,"email": result.valueForKey("email") as! String, "gender": result.valueForKey("gender") as! String, "locale": result.valueForKey("locale") as! String, "name": result.valueForKey("name") as! String,  /* "timezone": result.valueForKey("timezone") as! String, */ "updated_time": result.valueForKey("updated_time") as! String, "verified": result.valueForKey("verified") as! Bool, "access_token": FBSDKAccessToken.currentAccessToken().tokenString ]
                            
                            //                var myRootRef = Firebase(url:"https://luminous-heat-6986.firebaseio.com/")
                            
                            var userRef = myRootRef.childByAppendingPath("user")
                            ///Colocando o id do Facebook como id no FireBase
                            var infoAdd = userRef.childByAutoId()
                            infoAdd.setValue(info)
                            
                            //Salvando dados do usuário logado:
                            user.id = infoAdd.key
                            user.name = result.valueForKey("name")! as! String
                            user.email = result.valueForKey("email")! as! String
                            user.me = true
                            DAOLocal.sharedInstance.save()
                            
                            
                        }
                        callback(user)
                        
                    })
                }
            })
        })
    }
    
    
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        //        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        //        activityIndicator.frame = CGRectMake(100, 100, 100, 100)
        //        self.view.addSubview(activityIndicator)
        
        //        activityIndicator.startAnimating()
        
        registerUser(){ user in
            
            let listsController: ListsController = ListsController()
            self.navigationController?.pushViewController(listsController, animated: true)
            
            println("ja chegou a resposta")
            
            self.activityIndicator.stopAnimating()
            
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
}