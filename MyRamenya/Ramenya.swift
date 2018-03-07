//
//  Ramenya.swift
//  MyRamenya
//
//  Created by Kenneth Chen on 3/4/18.
//  Copyright © 2018 Ramen. All rights reserved.
//

import Foundation
import UIKit

struct Ramenya {
    
    var name = ""
    var id = ""
    var rating = 1.0
    var photoReference = ""
}

extension Ramenya : Serializable {
    var properties: Array<String> {
        return ["name", "id", "rating", "photoReference"]
    }
    
    func valueForKey(key: String) -> Any? {
        switch key {
        case "name":
            return name
        case "id":
            return id
        case "rating":
            return rating
        case "photoReference":
            return photoReference
        default:
            return nil
        }
    }
}
