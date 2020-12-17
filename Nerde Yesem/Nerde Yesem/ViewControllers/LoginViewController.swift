//
//  LoginViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 17.12.2020.
//

import UIKit

class LoginViewController: UIViewController {
    
    let username = "ozcan"
    
    @IBAction func loginTap(_ sender: UIButton) {
        if username == "ozcan" {
            performSegue(withIdentifier: "LocationViewSegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
