//
//  LoginViewController.swift
//  RealTime_iOS_chatApp
//
//  Created by Cumulations Technologies Private Limited on 18/07/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    let scrollView :UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    let logoImage : UIImageView  = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "logo")
        logoImage.contentMode = .scaleAspectFit
        return logoImage
    }()
    
    let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.returnKeyType = .continue
        emailTextField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 5, height: 0))//this helps to butter the overlapping of textfiled and placeholder
        emailTextField.leftViewMode = .always //this is must if u used leftview else it doesn't show buffer
        emailTextField.placeholder = "Enter email"
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderColor = UIColor.systemGray.cgColor
        emailTextField.layer.borderWidth = 1
        return emailTextField
    }()
    
    let passwordTextField : UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.returnKeyType = .done
        passwordTextField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordTextField.leftViewMode = .always
        passwordTextField.placeholder = "Enter password"
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = UIColor.systemGray.cgColor
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    let loginButton : UIButton = {
        let loginButton = UIButton()
        loginButton.backgroundColor = .link
        loginButton.setTitle("LogIn", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 10
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return loginButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "LogIn"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        //delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(logoImage)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        logoImage.frame = CGRect(x: scrollView.width/3, y: scrollView.top + 20, width: size, height: size)
        emailTextField.frame = CGRect(x: 30, y: logoImage.bottom + 30, width: scrollView.width - 60, height: 52)
        passwordTextField.frame = CGRect(x: emailTextField.left, y: emailTextField.bottom + 20, width: emailTextField.width, height: emailTextField.height)
        loginButton.frame = CGRect(x: emailTextField.left + 40, y: passwordTextField.bottom + 30, width: emailTextField.width - 80, height: emailTextField.height)
        
        
    }
    
    @objc private func loginButtonTapped(){
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty , password.count >= 6 else{
            validateFileds()
            return
        }
        //firebase login
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            guard let result = authResult, error == nil else{
                print("Failed to login with email: \(email)")
                return
            }
            
            let user = result.user
            print("\(user) was able to login successfully")
            
        }
        
    }
    private func validateFileds(){
        
        let alert = UIAlertController(title: "Log in error", message: "Please enter all the fields to log in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapRegister(){
        
        let vc = RegisterViewController()
        vc.title = "Register"
        navigationController?.pushViewController(vc, animated: false)
       
    }
    

}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            loginButtonTapped()
        }
        
        return true
    }
}
