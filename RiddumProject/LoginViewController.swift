//
//  LoginViewController.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-04-09.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // checks for user input in text fields when login button activated
    @IBAction func loginPressed(_ sender: Any) {
        guard emailField.text != "", passwordField.text != "" else {
            print("User not entered any information")
            return
        }
        
        // authorizes user account using firebase authentication
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            //presents tab bar controller
            if user != nil {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabVC")
                
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
}
