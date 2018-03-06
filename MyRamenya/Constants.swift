//
//  Constants.swift
//  MyRamenya
//
//  Created by Kenneth Chen on 3/4/18.
//  Copyright © 2018 Ramen. All rights reserved.
//

import Foundation

struct Constants {
    
    struct ParameterValues {
        static let ApiKey = "AIzaSyCDjJYdmOY1XPRfJ9MBsPHkW8u4H-y-oAo"
        static let Location = "25.0330,121.5654"
        static let Radius = 1000
        static let Keyword = "ramen"
        static let ApiHost = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    }
    
    struct ParameterKeys {
        static let ApiKey = "key"
        static let Location = "location"
        static let Radius = "radius"
        static let Keyword = "keyword"
    }
}
