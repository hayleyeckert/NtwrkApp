//
//  Ref.swift
//
//  Copyright (c) 2016 MizoApps. All rights reserved.
//


import UIKit
import Foundation

class DetailViewcontroller: UIViewController {
    
    @IBOutlet var detailImage: UIImageView!
    
    
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet weak var LocLabel: UILabel!
    @IBOutlet var PosLabel: UILabel!
    
    var RefImage = ""
    var RefName = ""
    var RefLoc = ""
    var RefPos = ""
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        detailImage.image = UIImage(named: RefImage)
        NameLabel.text = "\(RefName)"
        LocLabel.text = "\(RefLoc)"
        PosLabel.text = "\(RefPos)"

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
}
