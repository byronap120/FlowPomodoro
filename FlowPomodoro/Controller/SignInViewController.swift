//
//  SignInViewController.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 8/2/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func googleSignIn(_ sender: Any) {
    }
    
    @IBAction func goToApp(_ sender: Any) {
         self.performSegue(withIdentifier: "authUser", sender: "Byron")
    }
    
    @IBAction func guestMode(_ sender: Any) {
        self.performSegue(withIdentifier: "showTimer", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
