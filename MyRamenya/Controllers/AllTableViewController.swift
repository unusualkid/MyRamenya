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
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var appDelegate: AppDelegate!
    var ramenyas = [Ramenya]()
    let locationManager = CLLocationManager()
    var ref: DatabaseReference!
    let favoritePath = Constants.FirebasePath.Favorite
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLoadingScreen()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLoadingScreen()
        
    }
    
    @objc func logout() {
        dismiss(animated: true, completion: nil)
    }
    
    func callGooglePlaceSearch(location: String) {
        GooglePlacesAPI.sharedInstance.getRamenyasNearMe (location: location) { (result, error) in
            if let result = result {
                var ramenya = Ramenya()
                var counter = 0
                self.loadingView.isHidden = true
                self.activityIndicator.stopAnimating()
                for dict in result {
                    if let id = dict["id"] {
                        ramenya.id = id as! String
                    }
                    if let name = dict["name"] {
                        ramenya.name = name as! String
                    }
                    if let rating = dict["rating"] {
                        ramenya.rating = rating as! Double
                    }
                    
                    var photos = [[String : Any]]()
                    if let photoArrays = dict["photos"] {
                        photos = dict["photos"] as! [[String : Any]]
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
                self.removeLoadingScreen()
            } else {
                Utility.displayAlert(errorString: "Cannot load ramen restaurants. Check internet.", viewController: self)
                print("Validation error: \(error?.localizedDescription)")
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
            Utility.displayAlert(errorString: "Not connected to internet. Try again.", viewController: self)
            print(error.localizedDescription)
        }
    }
    
    private func setLoadingScreen() {
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
    }
    
    private func removeLoadingScreen() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func loadData() {
        
    }
}

extension AllTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Found user's location: \(locations)")
            Constants.ParameterValues.LocationCurrent = String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
            print("Constants.ParameterValues.LocationCurrent: \(Constants.ParameterValues.LocationCurrent)")
            callGooglePlaceSearch(location: Constants.ParameterValues.LocationCurrent)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        callGooglePlaceSearch(location:Constants.ParameterValues.LocationTokyo)
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
        
        GooglePlacesAPI.sharedInstance.getPhotos(photoReference: ramenya.photoReference) { (image, error) in
            cell.activityIndicator.stopAnimating()
            
            if let image = image {
                cell.ramenImage.image = image
                cell.activityIndicator.isHidden = true
            } else {
                Utility.displayAlert(errorString: "Cannot download pics. Check your internet.", viewController: self)
                print("Validation Error: \(error?.localizedDescription)")
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
