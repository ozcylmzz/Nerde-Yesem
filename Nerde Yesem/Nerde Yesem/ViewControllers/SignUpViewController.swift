//
//  SignUpViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 20.12.2020.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    print("basarili")
                }
            }
        }
        
    }
}
