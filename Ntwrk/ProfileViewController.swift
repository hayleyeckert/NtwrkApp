//
//  ProfileViewController.swift
//  Example
//
//  Created by Bill Newman on 1/27/18.
//  Copyright © 2018 Carma. All rights reserved.
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
    
    
    var NameString = String()
    var LocString = String()
    var PosString = String()
    var PicString = UIImage()
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
