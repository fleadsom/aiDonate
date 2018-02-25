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
    var hometown: String?
    
    func setHometown(h: Dictionary<String, Any>) {
        self.hometown = h["name"] as? String
    }
}
