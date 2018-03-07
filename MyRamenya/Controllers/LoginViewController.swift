//
//  LoginViewController.swift
//  MyRamenya
//
//  Created by Kenneth Chen on 12/26/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import UIKit
import CoreData
import FacebookCore
import FacebookLogin
import Firebase
import FirebaseDatabase
import FBSDKLoginKit

class LoginViewController: UIViewController, LoginButtonDelegate{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var auth: Auth?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FB needs to review the permissions before we can request them
        let reviewPermissions : [FacebookCore.ReadPermission] = [.userBirthday, .userLocation, .userWorkHistory, .userFriends, .userEducationHistory]
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends] + reviewPermissions)
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        auth = Auth.auth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        activityIndicator.startAnimating()
        loginButton.isHidden = true
        switch result {
        case .failed(let error):
            print(error)
            activityIndicator.stopAnimating()
            Utility.displayAlert(errorString: "Not connected to internet. Restart the app and try again.", viewController: self)
        case .cancelled:
            print("User cancelled login.")
            Utility.displayAlert(errorString: "User cancelled login.", viewController: self)
            activityIndicator.stopAnimating()
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            loginButton.isUserInteractionEnabled = false
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            // Perform login by calling Firebase APIs
            auth?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                let profile = FBSDKProfile.current()
                self.saveFacebookUserInfo()
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Logged out of fb")
    }
    
    func saveFacebookUserInfo() {
        if(FBSDKAccessToken.current() != nil)
        {
            //print permissions, such as public_profile
            //https://developers.facebook.com/docs/graph-api/reference/user
            print(FBSDKAccessToken.current().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email, gender, birthday, location, work, friends, education"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                if let error = error{
                    print(error.localizedDescription)
                }else{
                    let data = result as! [String : AnyObject]
                    let FBid = data["id"] as? String

                    //query firebase to see if this user exist?
                    let firebaseUid = self.auth?.currentUser?.uid
                    var ref = Database.database().reference().child("users")
                    ref.child(firebaseUid!).observeSingleEvent(of: .value, with: { (snapshot) in
                        var controller: UIViewController?
                        controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")

                        self.present(controller!, animated: true, completion: nil)
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
            })
            connection.start()
        }
    }
}

