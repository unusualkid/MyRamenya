//
//  GooglePlacesAPI.swift
//  MyRamenya
//
//  Created by Kenneth Chen on 3/8/18.
//  Copyright © 2018 Ramen. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class GooglePlacesAPI: NSObject {
    
    static let sharedInstance = GooglePlacesAPI()
    
    override init() {
        super.init()
    }
    
    func getRamenyasNearMe(location: String?, completionHandlerForGetRamenyasNearMe: @escaping (_ result: [[String : Any]]?, _ error: Error?) -> Void) {
        let url = Constants.Host.GooglePlace
        var param = [String:Any]()
        param[Constants.ParameterKeys.ApiKey] = Constants.ParameterValues.ApiKey
        param[Constants.ParameterKeys.Location] = location
        param[Constants.ParameterKeys.Radius] = Constants.ParameterValues.Radius
        param[Constants.ParameterKeys.Keyword] = Constants.ParameterValues.Keyword
        
        Alamofire.request(url, method: .get, parameters: param).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            switch response.result {
            case .success:
                print("Validation Successful")
                if let json = response.result.value {
                    print("json: \(json)")
                    let result = json as! [String : Any]
                    let dict = result["results"] as! [[String : Any]]
                    
                    completionHandlerForGetRamenyasNearMe(dict, nil)
                }
            case .failure(let error):
                completionHandlerForGetRamenyasNearMe(nil, error)
            }
            
        }
    }
    
    func getPhotos(photoReference: String, completionHandlerForGetPhotos: @escaping (_ result: Image?, _ error: Error?) -> Void) {
        let url = Constants.Host.GooglePhoto
        var param = [String:Any]()
        param[Constants.ParameterKeys.ApiKey] = Constants.ParameterValues.ApiKey
        param[Constants.ParameterKeys.MaxWidth] = Constants.ParameterValues.MaxWidth
        param[Constants.ParameterKeys.PhotoReference] = photoReference
        
        Alamofire.request(url, parameters: param).responseImage { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            switch response.result {
            case .success:
                print("photo download success")
                if let image = response.result.value {
                    completionHandlerForGetPhotos(image, nil)
                }
            case .failure(let error):
                completionHandlerForGetPhotos(nil, error)
            }
            
        }
    }
    
}

