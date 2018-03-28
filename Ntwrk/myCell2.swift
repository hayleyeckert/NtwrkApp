//
//  myCell2.swift
//  Ntwrk
//

import UIKit

class myCell2: UITableViewCell {
    
    @IBOutlet var myImageView: UIImageView!
    
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var PosLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
