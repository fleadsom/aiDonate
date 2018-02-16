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
    
    // Login View properties
    @IBOutlet var loginView: UIView!
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {

        print("Facebook Login Successful")
        
        //getUserData() // export user details
        
        // redirect to main page
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
            let loginButton = LoginButton(readPermissions: [ .publicProfile, .userLikes, .userHometown ])
            loginButton.delegate = self
            loginButton.center = view.center
            view.addSubview(loginButton)
        }
    }
    
//    // Get user data and output it to a file
//    func getUserData() {
//        struct MyProfileRequest: GraphRequestProtocol {
//            struct Response: GraphResponseProtocol {
//
//                var name: String?
//                var id: String?
//                var likes: String?
//                var hometown: String?
//                var profilePictureUrl: String?
//
//                init(rawResponse: Any?) {
//                    // Decode JSON from rawResponse into other properties here.
//                    guard let response = rawResponse as? Dictionary<String, Any> else {
//                        return
//                    }
//
//                    if let name = response["name"] as? String {
//                        self.name = name
//                    }
//
//                    if let id = response["id"] as? String {
//                        self.id = id
//                    }
//
//                    if let likes = response["likes"] as? String {
//                        self.likes = likes
//                    }
//
//                    if let hometown = response["hometown"] as? String {
//                        self.hometown = hometown
//                    }
//
//                    if let picture = response["picture"] as? Dictionary<String, Any> {
//
//                        if let data = picture["data"] as? Dictionary<String, Any> {
//                            if let url = data["url"] as? String {
//                                self.profilePictureUrl = url
//                            }
//                        }
//                    }
//                }
//            }
//            var graphPath = "/me"
//            var parameters: [String : Any]? = ["fields": "id, name"]
//            var accessToken = AccessToken.current
//            var httpMethod: GraphRequestHTTPMethod = .GET
//            var apiVersion: GraphAPIVersion = .defaultVersion
//        }
//
//        let connection = GraphRequestConnection()
//        connection.add(MyProfileRequest()) { response, result in
//            switch result {
//            case .success(let response):
//                print("Custom Graph Request Succeeded: \(response)")
//                print("My facebook id is \(response.id!)")
//                print("My name is \(response.name!)")
//            case .failed(let error):
//                print("Custom Graph Request Failed: \(error)")
//            }
//        }
//        connection.start()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

