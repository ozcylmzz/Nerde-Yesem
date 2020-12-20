//
//  LoginViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 17.12.2020.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func loginTap(_ sender: UIButton) {
  
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "LocationViewSegue", sender: self)
                }
            }
        }
    }
}
