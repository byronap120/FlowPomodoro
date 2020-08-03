//
//  SignInViewController.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 8/2/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class SignInViewController: UIViewController, GIDSignInDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        let user = Auth.auth().currentUser
        if user != nil {
           userIsAuthenticated()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "authUser" {
            if let tabController = segue.destination as? UITabBarController {
                let timerViewController = tabController.viewControllers?.first as! TimerViewController
                let username = sender as! String
                timerViewController.username = username
            }
        }
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error != nil) {
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: result?.token?.tokenString ?? "")
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.userIsAuthenticated()
                }
            }
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func goToApp(_ sender: Any) {
        self.performSegue(withIdentifier: "authUser", sender: "Byron")
    }
    
    @IBAction func guestMode(_ sender: Any) {
        self.performSegue(withIdentifier: "showTimer", sender: nil)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful")
                self.userIsAuthenticated()
            }
        }
    }
    
    private func userIsAuthenticated(){
        let user = Auth.auth().currentUser
        self.performSegue(withIdentifier: "authUser", sender: user?.displayName)
    }
    
    
}
