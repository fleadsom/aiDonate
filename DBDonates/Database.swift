//
//  Database.swift
//  DBDonates
//
//  Created by Freddie Leadsom on 11/06/2019.
//  Copyright © 2019 CS301. All rights reserved.
//

import Foundation
import FacebookCore
import SQLite3

class Database {
    
    // Get user data and output it to a file
    func getUserData() -> String {
        
        var returnable = "";
        
        struct MyProfileRequest: GraphRequestProtocol {
            struct Response: GraphResponseProtocol {
                
                var name: String?
                var id: String?
                var likes: Dictionary<String, Any>?
                var hometown: Dictionary<String, Any>?
                var profilePictureUrl: String?
                var friends: String?
                
                init(rawResponse: Any?) {
                    // Decode JSON from rawResponse into other properties here.
                    guard let response = rawResponse as? Dictionary<String, Any> else {
                        return
                    }
                    
                    if let name = response["name"] as? String {
                        self.name = name
                    }
                    
                    if let id = response["id"] as? String {
                        self.id = id
                    }
                    
                    if let likes = response["likes"] as? Dictionary<String, Any> {
                        self.likes = likes
                    }
                    
                    if let friends = response["friends"] as? String {
                        self.friends = friends
                    }
                    
                    if let hometown = response["hometown"] as? Dictionary<String, Any> {
                        self.hometown = hometown
                    }
                    
                    if let picture = response["picture"] as? Dictionary<String, Any> {
                        
                        if let data = picture["data"] as? Dictionary<String, Any> {
                            if let url = data["url"] as? String {
                                self.profilePictureUrl = url
                            }
                        }
                    }
                }
            }
            var graphPath = "/me"
            var parameters: [String : Any]? = ["fields": "id, name, picture.type(large), hometown, likes"]
            var accessToken = AccessToken.current
            var httpMethod: GraphRequestHTTPMethod = .GET
            var apiVersion: GraphAPIVersion = .defaultVersion
        }
        
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response): // on completion and result sucessfully returned (asynchronous)
                
                print("Custom Graph Request Succeeded: \(response)")
                
                print("user hometown: \(response.hometown!["name"])")
                
                // return hometown
                returnable = String(describing: response.hometown!["name"])
                
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
        return returnable
    }
}

