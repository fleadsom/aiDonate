//
//  Users.swift
//  DBDonates
//
//  Created by Freddie Leadsom on 02/03/2018.
//  Copyright © 2018 CS301. All rights reserved.
//

import Foundation

class Users {
    
    init(id: Int!, u: String?, ppurl: String?) {
        self.username = u
        self.profile_picture_url = ppurl
    }
    
    var username: String?
    var profile_picture_url: String?
}
