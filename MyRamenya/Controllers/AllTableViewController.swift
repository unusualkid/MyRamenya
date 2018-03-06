//
//  AllTableViewController.swift
//  MyRamenya
//
//  Created by Kenneth Chen on 3/4/18.
//  Copyright © 2018 Ramen. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class TableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ramenImage: UIImageView!
}

class AllTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var appDelegate: AppDelegate!
    var ramenyas = [Ramenya]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in viewDidLoad")
        
        let url = Constants.Host.GooglePlace
        
        var param = [String:Any]()
        param[Constants.ParameterKeys.ApiKey] = Constants.ParameterValues.ApiKey
        param[Constants.ParameterKeys.Location] = Constants.ParameterValues.Location
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
                    var ramenya = Ramenya()
                    var counter = 0

                    for d in dict {
                        if let id = d["id"] {
                            ramenya.id = id as! String
                        }
                        if let name = d["name"] {
                            ramenya.name = name as! String
                        }
                        if let rating = d["rating"] {
                            ramenya.rating = rating as! Double
                        }
                        
                        let photos = d["photos"] as! [[String : Any]]
                        
                        if let photoDict = photos.first {
                            if let photoReference = photoDict["photo_reference"] {
                                print("photoReference: \(photoReference)")
                                ramenya.photoReference = photoReference as! String
                            }
                        }
                        self.ramenyas.append(ramenya)
                    }
                    print("self.ramenyas: \(self.ramenyas)")
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Validation Error: \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    @objc func logout() {
        dismiss(animated: true, completion: nil)
    }
}

extension AllTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ramenya = ramenyas[(indexPath as NSIndexPath).row]
        
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TableViewCell
        cell.nameLabel.text = ramenya.name
        cell.ratingLabel.text = "Rating: \(String(ramenya.rating))"
        
        let url = Constants.Host.GooglePhoto
        var param = [String:Any]()
        param[Constants.ParameterKeys.ApiKey] = Constants.ParameterValues.ApiKey
        param[Constants.ParameterKeys.MaxWidth] = Constants.ParameterValues.MaxWidth
        param[Constants.ParameterKeys.PhotoReference] = ramenya.photoReference

        Alamofire.request(url, parameters: param).responseImage { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            switch response.result {
            case .success:
                print("photo download success")
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cell.ramenImage.image = image
                }
            case .failure(let error):
                print("Validation Error: \(error)")
            }

        }
        
//        Alamofire.request(url, method: .get, parameters: param).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//            print("Success: \(response.result.isSuccess)")
//            print("Response String: \(response.result.value)")
////            switch response.result {
////            case .success:
////                print("photo download success")
//////                cell.ramenImage.image =
////            case .failure(let error):
////                print("Validation Error: \(error)")
////            }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ramenyas.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
