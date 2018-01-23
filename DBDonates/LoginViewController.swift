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

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {

        // Recognise click on login with Facebook
        let gestureRecognizer = UITapGestureRecognizer(target: loginButton, action: Selector("handleTap")) // create a gesture recognizer for login button
        loginButton.addGestureRecognizer(gestureRecognizer) // add the recognizer to the button
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        <#code#>
    }
    
    
    // Login View properties
    @IBOutlet var loginView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // If user is already logged in, don't bother going to facebook
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
        }
        else {
            
            // Facebook login button
            let loginButton = LoginButton(readPermissions: [ .publicProfile ])
            loginButton.center = view.center
            view.addSubview(loginButton)
        }
    }
    
    // Handle the action when a user  clicks on the login button
    func handleTap(sender: UITapGestureRecognizer) {
        print("going into handletap")
        if sender.state == .ended {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CharitiesViewController")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

