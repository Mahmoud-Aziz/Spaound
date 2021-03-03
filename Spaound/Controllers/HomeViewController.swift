//
//  HomeViewController.swift
//  Spaound
//
//  Created by Mahmoud Aziz on 03/03/2021.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        
        if !isLoggedIn {
            
            let vc = EntryAuthenticationViewController()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    
}
