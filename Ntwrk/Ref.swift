//
//  Ref.swift
//  Ntwrk
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
