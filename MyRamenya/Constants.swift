//
//  Constants.swift
//  MyRamenya
//
//  Created by Kenneth Chen on 3/4/18.
//  Copyright © 2018 Ramen. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Host {
        static let GooglePlace = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        static let GooglePhoto = "https://maps.googleapis.com/maps/api/place/photo?"
    }
    
    struct ParameterValues {
        static let ApiKey = "AIzaSyCDjJYdmOY1XPRfJ9MBsPHkW8u4H-y-oAo"
        static var Location = "35.6895, 139.6917"
        static let Radius = 1000
        static let Keyword = "ramen"
        
        static let MaxWidth = 400
        static let PhotoHost = "https://maps.googleapis.com/maps/api/place/photo?"
    }
    
    struct ParameterKeys {
        static let ApiKey = "key"
        static let Location = "location"
        static let Radius = "radius"
        static let Keyword = "keyword"
        
        static let MaxWidth = "maxwidth"
        static let PhotoReference = "photo_reference"
    }
}
