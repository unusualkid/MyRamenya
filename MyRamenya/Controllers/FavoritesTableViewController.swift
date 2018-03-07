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
    var ramenyas = [Ramenya]()
    let url = Constants.Host.GooglePlace
    var ref: DatabaseReference!
    
    let favoritePath = "my_favorites"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    @objc func logout() {
        dismiss(animated: true, completion: nil)
    }

    func saveToFireBase(_ placeToSave: Any){
        ref.child(favoritePath).childByAutoId().setValue(placeToSave)
    }

    func getFromFavorites(){
        ref.child(favoritePath).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                print(value)
            }
            //load value to some table view datasource?
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func removeFromFavotires(id: String){
        ref.child(favoritePath).child(id).removeValue()
    }
}

extension FavoritesTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ramenyas.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
