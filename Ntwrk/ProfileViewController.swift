//
//  ProfileViewController.swift
//  Example
//
//  Created by Bill Newman on 1/27/18.
//

import UIKit
import Foundation

class ProfileViewController: UIViewController {

    @IBOutlet weak var ProfPic: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var LocLabel: UILabel!
    @IBOutlet weak var PosLabel: UILabel!
    
    @IBAction func JoinRoom(_ sender: Any) {
        
    }
    
    
    @objc var NameString = String()
    @objc var LocString = String()
    @objc var PosString = String()
    @objc var PicString = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(PicString)
        NameLabel.text = NameString
        LocLabel.text = LocString
        PosLabel.text = PosString
        ProfPic.image = PicString
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
