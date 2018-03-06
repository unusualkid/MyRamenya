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

class TableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
}

class AllTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var appDelegate: AppDelegate!
    var ramenyas = [Ramenya]()
    let url = Constants.ParameterValues.ApiHost
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in viewDidLoad")
        
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
                        if let photo = d["photos"] {
                            print("photo: \(photo)")
//                            let photoDict = photo as! [String: Any]
//                            if let photoReference = photoDict["photo_reference"] {
//                                print("IN PhotoReference")
//                            }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ramenyas.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
