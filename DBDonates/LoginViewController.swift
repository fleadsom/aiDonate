//
//  LoginViewController.swift
//  DBDonates
//
//  Created by Freddie Leadsom on 14/11/2017.
//  Copyright © 2017 CS301. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController {
    
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
            
            // Recognise click on login with Facebook
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            loginButton.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CharitiesViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

