//
//  CityViewController.swift
//  MyRamenya
//
//  Created by Kenneth Chen on 3/4/18.
//  Copyright © 2018 Ramen. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire

class CityViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    let url = Constants.Host.GooglePlace
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        print("buttonPressed")
    }
}

