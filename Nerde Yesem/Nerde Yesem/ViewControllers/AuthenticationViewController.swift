//
//  AuthenticationViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 13.12.2020.
//

import UIKit
import LocalAuthentication

class AuthenticationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticationUser()
    }
    
    func authenticationUser(){
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                (success, authenticationError) in

                DispatchQueue.main.async {
                    if success {
                        print("succesfull face id")
                        self.performSegue(withIdentifier: "LocationViewSegue", sender: self)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
}
