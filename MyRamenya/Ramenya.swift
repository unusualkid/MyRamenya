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
    
    // MARK: Properties
    
    let title: String
    let id: Int
    let posterPath: String?
    
    // MARK: Initializers
    
    init(dictionary: [String:AnyObject]) {
        title = "" as! String
        id = "" as! Int
        posterPath = "" as? String
    }
    
    static func ramenyasFromResults(_ results: [[String:AnyObject]]) -> [Ramenya] {
        
        var ramenyas = [Ramenya]()
        
        // iterate through array of dictionaries, each Ramenya is a dictionary
        for result in results {
            ramenyas.append(Ramenya(dictionary: result))
        }
        
        return ramenyas
    }
    
}

// MARK: - Movie: Equatable

extension Ramenya: Equatable {}

func ==(lhs: Ramenya, rhs: Ramenya) -> Bool {
    return lhs.id == rhs.id
}
