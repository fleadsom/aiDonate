//
//  SettingsViewController.swift
//  DBDonates
//
//  Created by Freddie Leadsom on 18/02/2018.
//  Copyright © 2018 CS301. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class SettingsViewController: UIViewController, LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {}
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {

        // send user back to login screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Facebook login button (will display as logout button when user is logged in)
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .userLikes, .userHometown ]) // set logout button
        loginButton.center = view.center // center logout button
        loginButton.delegate = self // assign delegate to self (from loginviewcontroller)
        view.addSubview(loginButton) // display button
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
