//
//  FavoritesTableViewController.swift
//  MyRamenya
//
//  Created by Kenneth Chen on 3/4/18.
//  Copyright © 2018 Ramen. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Firebase


class FavoritesTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var appDelegate: AppDelegate!
    var favorites = [[String: Any]]()
    let url = Constants.Host.GooglePlace
    var ref: DatabaseReference!
    
    let favoritePath = Constants.FirebasePath.Favorite
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        getFromFavorites()
    }
    
    @objc func logout() {
        dismiss(animated: true, completion: nil)
    }

    func getFromFavorites(){
        self.favorites = []
        ref.child(favoritePath).observeSingleEvent(of: .value, with: { (snapshot) in
            print("snapshot: \(snapshot)")
            if let value = snapshot.value as? [String : [String : Any]] {
                for (k, v) in value {
                    var favorite = v
                    print("k: \(k)")
                    print("v: \(v)")
                    favorite["firebaseId"] = k
                    self.favorites.append(favorite)
                }
                print("self.favorites: \(self.favorites)")
                self.tableView.reloadData()
            } else {
                Utility.displayAlert(errorString: "Not connected to internet. Try again.", viewController: self)
                print("error retrieving data.")
            }
        })
    }

    func removeFromFavotires(firebaseId: String){
        ref.child(favoritePath).child(firebaseId).removeValue()
        getFromFavorites()
    }

}

extension FavoritesTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favorite = favorites[(indexPath as NSIndexPath).row]
        
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TableViewCell
        cell.nameLabel.text = favorite["name"] as! String
        
        var ratingString = ""
        if let rating = favorite["rating"] {
            ratingString = String(describing: rating)
        }
        
        cell.ratingLabel.text = "Rating: \(ratingString)"
        
        cell.activityIndicator.startAnimating()
        
        GooglePlacesAPI.sharedInstance.getPhotos(photoReference: favorite["photoReference"] as! String) { (image, error) in
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
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .normal, title: "Remove") { action, index in
            print("remove button tapped")
            
            let ramenya = self.favorites[(indexPath as NSIndexPath).row]
            
            self.removeFromFavotires(firebaseId: ramenya["firebaseId"] as! String)
        }
        remove.backgroundColor = UIColor.gray
        
        return [remove]
    }
}
