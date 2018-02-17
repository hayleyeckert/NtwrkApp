//
//  Food.swift
//  yummyDesserts2
//
//  Created by Susan Starkman on 7/28/15.
//  Copyright (c) 2015 The Code Lady. All rights reserved.
//

import Foundation

class Ref {
   
    var imageName = ""
    var description = ""
    var position = ""
    var location = ""
    
    init (imageName: String, description: String, position: String, location: String) {
    
        self.imageName = imageName
        self.description = description
        self.position = position
        self.location = location
    }
}
