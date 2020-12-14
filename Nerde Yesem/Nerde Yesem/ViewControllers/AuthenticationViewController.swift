//
//  AuthenticationViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 13.12.2020.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentication()
    }
    
    func authentication(){
        self.performSegue(withIdentifier: "LocationViewSegue", sender: self)
    }
}
