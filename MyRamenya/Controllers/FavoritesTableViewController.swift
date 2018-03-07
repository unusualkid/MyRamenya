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
    
    let favoritePath = Constants.FirebasePath.Favorite
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        getFromFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    @objc func logout() {
        dismiss(animated: true, completion: nil)
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

    func removeFromFavotires(firebaseId: String){
        ref.child(favoritePath).child(firebaseId).removeValue()
    }

}

extension FavoritesTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .normal, title: "Remove") { action, index in
            print("favorite button tapped")
            
            let ramenya = self.ramenyas[(indexPath as NSIndexPath).row]
            let ramenDict = ramenya.toDictionary()
            print("ramenDict: \(ramenDict)")

        }
        remove.backgroundColor = UIColor.gray
        
        return [remove]
    }
}
