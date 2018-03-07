//
//  Utility.swift
//  MyRamenya
//
//  Created by Kenneth Chen on 3/7/18.
//  Copyright © 2018 Ramen. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    static func displayAlert(errorString: String?, viewController: UIViewController) {
        let controller = UIAlertController()
        
        if let errorString = errorString {
            controller.message = errorString
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)
        viewController.present(controller, animated: true, completion: nil)
    }
}
