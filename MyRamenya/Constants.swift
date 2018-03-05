//
//  Constants.swift
//  MyRamenya
//
//  Created by Kenneth Chen on 3/4/18.
//  Copyright © 2018 Ramen. All rights reserved.
//

import Foundation

class Contacts {
    // MARK: TMDB
    struct TMDB {
        static let ApiScheme = "http"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
    }
    
    // MARK: TMDB Parameter Keys
    struct TMDBParameterKeys {
        static let ApiKey = "api_key"
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: TMDB Parameter Values
    struct TMDBParameterValues {
        static let ApiKey = "YOUR_API_KEY_HERE"
    }
    
    // MARK: TMDB Response Keys
    struct TMDBResponseKeys {
        static let Title = "title"
        static let ID = "id"
        static let PosterPath = "poster_path"
        static let StatusCode = "status_code"
        static let StatusMessage = "status_message"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Success = "success"
        static let UserID = "id"
        static let Results = "results"
    }
    
}
