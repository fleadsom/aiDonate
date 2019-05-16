//
//  CharityTableViewCell.swift
//  DBDonates
//
//  Created by Freddie Leadsom on 28/02/2018.
//  Copyright © 2018 CS301. All rights reserved.
//

import UIKit

class CharityTableViewCell: UITableViewCell {

    // control name of charity displayed
    @IBOutlet weak var charityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
