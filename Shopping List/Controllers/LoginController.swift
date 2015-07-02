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
<<<<<<< HEAD


=======
    

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
                            
                            //Donwload da foto do usuário:
                            let url = NSURL(string: dic[key]!.objectForKey("photo")! as! String)
                            let imageData = NSData(contentsOfURL: url!)
                            var image : UIImage = UIImage(data: imageData!)!
                            DAOLocal.sharedInstance.saveImageOfUser(image, user: DAOLocal.sharedInstance.readUser())
                            
                            //Pegando os amigos do Facebook e fazendo download das fotos:
                            FunctionsFacebook.sharedInstance.getFacebookFriendsFromUser()
                            
                            println("User ja estava Registrado")
                            
                            self.trackEvent("User", action: "Login", label: "Returning User", value: 10)
                            
                        }
                        else {
                            
                            //Carregando a imagem:
                            let data: AnyObject? = result2.valueForKey("data")
                            let url = NSURL(string: data!.valueForKey("url") as! String)

                            println("User não encontrado. Tem q registrar!")
                            println("fetched user: \(result)")
                            let userName : NSString = result.valueForKey("name") as! NSString
                            println("User Name is: \(userName)")
                            let userEmail : NSString = result.valueForKey("email") as! NSString
                            println("User Email is: \(userEmail)")
                            var info = ["idfb": result.valueForKey("id") as! String, "photo": data!.valueForKey("url") as! String, "email": result.valueForKey("email") as! String, "gender": result.valueForKey("gender") as! String, "locale": result.valueForKey("locale") as! String, "name": result.valueForKey("name") as! String,  /* "timezone": result.valueForKey("timezone") as! String, */ "updated_time": result.valueForKey("updated_time") as! String, "verified": result.valueForKey("verified") as! Bool, "access_token": FBSDKAccessToken.currentAccessToken().tokenString]
                            
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
                            
                            ///Salvando a imagem
                            let imageData = NSData(contentsOfURL: url!)
                            var image : UIImage = UIImage(data: imageData!)!
                            DAOLocal.sharedInstance.saveImageOfUser(image, user: DAOLocal.sharedInstance.readUser())
                            
                            //Pegando os amigos do Facebook e fazendo download das fotos:
                            FunctionsFacebook.sharedInstance.getFacebookFriendsFromUser()
                            
                            self.trackEvent("User", action: "Login", label: "Register New User", value: 10)
                            
                        }
                    callback(user)
                    })
                }
            })
        })
    }
>>>>>>> origin/master
    
}