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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        googleLoginButton.imageView?.contentMode = .scaleAspectFit
        facebookLoginButton.imageView?.contentMode = .scaleAspectFit
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        checkUserAuthState()
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
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func goToApp(_ sender: Any) {
        self.performSegue(withIdentifier: "authUser", sender: "Byron")
    }
    
    @IBAction func guestMode(_ sender: Any) {
        self.performSegue(withIdentifier: "showTimer", sender: nil)
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error != nil) {
                return
            }
            FirebaseAPI.signInWithFacebook(accessToken: result?.token?.tokenString ?? "", completionHandler: self.userSignInHandler(success:error:))
        }
    }
        
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        FirebaseAPI.signInWithGoogle(idToken: auth.idToken, accessToken: auth.accessToken, completionHandler: self.userSignInHandler(success:error:))
    }
    
    private func userSignInHandler(success: Bool, error: Error?) {
        if(success) {
            checkUserAuthState()
        } else {
            if let errorMessage = error?.localizedDescription {
                showAlertMessage(title: "Error", message: errorMessage)
            }
        }
    }
    
    private func checkUserAuthState(){
        if let user = FirebaseAPI.isUserAuthenticated() {
            self.performSegue(withIdentifier: "authUser", sender: user)
        }
    }
    
}
