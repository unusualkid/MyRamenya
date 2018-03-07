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
import CoreLocation
import Firebase


class AllTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var appDelegate: AppDelegate!
    var ramenyas = [Ramenya]()
    let locationManager = CLLocationManager()
    var ref: DatabaseReference!
    let favoritePath = Constants.FirebasePath.Favorite
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in viewDidLoad")
        
        ref = Database.database().reference()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    @objc func logout() {
        dismiss(animated: true, completion: nil)
    }
    
    func callGooglePlaceSearch() {
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
                        
                        var photos = [[String : Any]]()
                        if let photoArrays = d["photos"] {
                            photos = d["photos"] as! [[String : Any]]
                        }
                        
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
    
    
    func saveToFireBase(_ dict: [String : Any]) {
        ref.child(favoritePath).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                var idExists = false
                var firebaseId = ""
                for (k, v) in value {
                    let favorite = v as! [String : Any]
                    print("favorite['id']: \(favorite["id"])")
                    if dict["id"] as! String == favorite["id"] as! String {
                        idExists = true
                        firebaseId = k
                    }
                    print("idExists: \(idExists)")
                }
                
                if idExists {
                    print("self.ref.child(self.favoritePath).child(firebaseId): \(self.ref.child(self.favoritePath).child(firebaseId))")
                    self.ref.child(self.favoritePath).child(firebaseId).setValue(dict)
                } else {
                    self.ref.child(self.favoritePath).childByAutoId().setValue(dict)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }    
}

extension AllTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Found user's location: \(locations)")
            Constants.ParameterValues.Location = String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
            print("Constants.ParameterValues.Location: \(Constants.ParameterValues.Location)")
            callGooglePlaceSearch()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        callGooglePlaceSearch()
    }
}

extension AllTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ramenya = ramenyas[(indexPath as NSIndexPath).row]
        
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TableViewCell
        cell.nameLabel.text = ramenya.name
        cell.ratingLabel.text = "Rating: \(String(ramenya.rating))"
        
        cell.activityIndicator.startAnimating()
        
        let url = Constants.Host.GooglePhoto
        var param = [String:Any]()
        param[Constants.ParameterKeys.ApiKey] = Constants.ParameterValues.ApiKey
        param[Constants.ParameterKeys.MaxWidth] = Constants.ParameterValues.MaxWidth
        param[Constants.ParameterKeys.PhotoReference] = ramenya.photoReference
        
        Alamofire.request(url, parameters: param).responseImage { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            cell.activityIndicator.stopAnimating()
            switch response.result {
            case .success:
                print("photo download success")
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cell.ramenImage.image = image
                }
                cell.activityIndicator.isHidden = true
            case .failure(let error):
                print("Validation Error: \(error)")
            }

        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ramenyas.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            print("favorite button tapped")
            
            let ramenya = self.ramenyas[(indexPath as NSIndexPath).row]
            let ramenDict = ramenya.toDictionary()
            print("ramenDict: \(ramenDict)")
            self.saveToFireBase(ramenDict)
        }
        favorite.backgroundColor = UIColor.red
        
        return [favorite]
    }
}
