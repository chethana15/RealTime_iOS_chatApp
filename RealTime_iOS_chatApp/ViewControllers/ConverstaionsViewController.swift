//
//  ViewController.swift
//  RealTime_iOS_chatApp
//
//  Created by Cumulations Technologies Private Limited on 14/07/22.
//

import UIKit
import FirebaseAuth

class ConverstaionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        
//        DatabaseManager.shared.test()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        create a value for log_in
//        let logIn = UserDefaults.standard.bool(forKey: "Log_in")
        validateLogin()
        
        
    }

    private func validateLogin(){
        //if user is not logged in then direct them to login vc
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController.init(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)//when animation is set to true delay will be more so prefer setting to false
        }
    }


}

