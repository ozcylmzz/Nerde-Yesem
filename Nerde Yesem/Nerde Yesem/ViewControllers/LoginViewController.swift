//
//  LoginViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 17.12.2020.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginTap(_ sender: UIButton) {
  
        if let email = emailTextField.text, let password = passwordTextField.text {
//            Auth.auth().signIn(withEmail: "1@2.com", password: "123456") { authResult, error in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    let ac = UIAlertController(title: "Authentication failed", message: e.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                } else {
                    self.performSegue(withIdentifier: "LocationViewSegue", sender: self)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
