//
//  myCell2.swift
//  SuperCool_V.2
//
//  Created by Michayal Mathew on 7/14/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class myCell2: UITableViewCell {
    
    @IBOutlet var myImageView: UIImageView!
    
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var PosLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
