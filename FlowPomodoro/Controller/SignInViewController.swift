//
//  SignInViewController.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 8/2/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class SignInViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var screenLoader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleLoginButton.imageView?.contentMode = .scaleAspectFit
        facebookLoginButton.imageView?.contentMode = .scaleAspectFit
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        checkUserAuthState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "authUser" {
            if let tabController = segue.destination as? UITabBarController {
                let user = sender as! User
                
                let timerViewController = tabController.viewControllers?[0] as! TimerViewController
                timerViewController.user = user
                
                let taskTableViewController = tabController.viewControllers?[1] as! TaskTableViewController
                taskTableViewController.user = user
            }
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        screenLoader.isHidden = false
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func guestMode(_ sender: Any) {
        self.performSegue(withIdentifier: "showTimer", sender: nil)
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        screenLoader.isHidden = false
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error != nil) {
                self.screenLoader.isHidden = true
                return
            }
            FirebaseAPI.signInWithFacebook(accessToken: result?.token?.tokenString ?? "", completionHandler: self.userSignInHandler(success:error:))
        }
    }
    
    private func userSignInHandler(success: Bool, error: Error?) {
        if(success) {
            checkUserAuthState()
        } else {
            if let errorMessage = error?.localizedDescription {
                showAlertMessage(title: "Error", message: errorMessage)
                screenLoader.isHidden = true
            }
        }
    }
    
    private func checkUserAuthState(){
        if let user = FirebaseAPI.isUserAuthenticated() {
            screenLoader.isHidden = true
            self.performSegue(withIdentifier: "authUser", sender: user)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            self.screenLoader.isHidden = true
            return
        }
        guard let auth = user.authentication else { return }
        FirebaseAPI.signInWithGoogle(idToken: auth.idToken, accessToken: auth.accessToken, completionHandler: self.userSignInHandler(success:error:))
    }
}
