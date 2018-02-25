//
//  SettingsViewController.swift
//  DBDonates
//
//  Created by Freddie Leadsom on 18/02/2018.
//  Copyright © 2018 CS301. All rights reserved.
//

import UIKit
import FacebookLogin

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Facebook login button
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .userLikes, .userHometown ])
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        // Do any additional setup after loading the view.
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
