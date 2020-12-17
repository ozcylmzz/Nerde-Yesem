//
//  AuthenticationViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 13.12.2020.
//

import UIKit
import LocalAuthentication

class AuthenticationViewController: UIViewController {
 
    @IBOutlet weak var loginButton: UIButton!
    var context = LAContext()
    var result: Bool = false

    enum AuthenticationState {
        case loggedin, loggedout
    }

    var state = AuthenticationState.loggedout {

        didSet {

            if state == .loggedin {
                
                performSegue(withIdentifier: "LoginSegue", sender: nil)
            
            }
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
        
    }

    @IBAction func tapButton(_ sender: UIButton) {
        
        authUser()
        
    }
    
    func authUser() {
        
        if state == .loggedin {
        
        state = .loggedout

        } else {

            context = LAContext()

            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

                    if success {

                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                        }

                    } else {
                        
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                        
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Can't evaluate policy")
                let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
}
