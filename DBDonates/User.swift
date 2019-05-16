//
//  User.swift
//  DBDonates
//
//  Created by Freddie Leadsom on 18/02/2018.
//  Copyright © 2018 CS301. All rights reserved.
//

import Foundation

class User {
    class var sharedInstance: User {
        struct Static {
            static let instance = User()
        }
        return Static.instance
    }
    
    var userId: Int!
    var username: String?
    var profile_picture_url: String?
    var hometown: String?
    
    func setHometown(h: Dictionary<String, Any>) {
        self.hometown = h["name"] as? String
    }
    func setUsername(u: String) {
        self.username = u
    }
    func setPPURL(url: String) {
        self.profile_picture_url = url
    }
}
