 //
//  LoginViewController.swift
//  Twitter
//
//  Created by Reza Enayati on 3/5/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Making sure the user stays logged in after closing the session.
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            UserDefaults.standard.set(false, forKey: "userLoggedIn")
        }
    }
    
    
    
    
    //Login function using thr API
    @IBAction func onLoginButton(_ sender: Any) {
        let loginUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: loginUrl, success: {
            
            //Keeping the user logged in after closing the seesion
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            
            //Perforing the Segue
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (error) in
            print("Could not login!")
        })
    }

}
