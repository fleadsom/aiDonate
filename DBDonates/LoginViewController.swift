//
//  LoginViewController.swift
//  DBDonates
//
//  Created by Freddie Leadsom on 14/11/2017.
//  Copyright © 2017 CS301. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FacebookShare

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    // Login View properties
    @IBOutlet var loginView: UIView!
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {

        print("Facebook Login Successful")
        
        // redirect to main page on login
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {}
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // If user is already logged in, don't bother going to facebook
        if let accessToken = AccessToken.current {
            
            // User is logged in, redirect to main page
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            self.present(vc, animated: true, completion: nil)
        }
            
        else {
            
            // Facebook login button
            let loginButton = LoginButton(readPermissions: [ .publicProfile, .userLikes, .userHometown, .userFriends ])
            loginButton.delegate = self
            loginButton.center = view.center
            view.addSubview(loginButton)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

