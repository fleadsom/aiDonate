//
//  AreaGroup.swift
//  DBDonates
//
//  Created by Freddie Leadsom on 05/03/2018.
//  Copyright © 2018 CS301. All rights reserved.
//

import Foundation

class AreaGroup {
    
    init(area: String, charities: [String]) {
        self.area = area
        self.charities = charities
    }
    
    var area = ""
    var charities = [String]()
}
