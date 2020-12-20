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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func loginTap(_ sender: UIButton) {
  
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: "1@2.com", password: "123456") { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "LocationViewSegue", sender: self)
                }
            }
        }
    }
}
