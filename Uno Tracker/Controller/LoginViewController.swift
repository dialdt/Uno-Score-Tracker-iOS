//
//  LoginViewController.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 22/08/2022.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

//import FirebaseAuthUI
//import FirebaseGoogleAuthUI

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    var userId: String = "test"
    
    @IBOutlet var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.hidesBackButton = true
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        tabBarController?.tabBar.isHidden = true
        

        //authUI?.delegate = self
        //authUI?.providers = providers
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func loginButtonTapped(_ sender: GIDSignInButton) {
        print(GIDSignIn.sharedInstance())
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let e = error {
            print(e)
            return
        }
        guard let auth = user.authentication else {return}
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credentials) { authResult, error in
            if let e = error {
                print(e)
                return
            }
            
            print("successful login!", user.profile.email)
            //self.userId = user.profile.email
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MainViewController
        destinationVC.userID = userId
        
    }

}
