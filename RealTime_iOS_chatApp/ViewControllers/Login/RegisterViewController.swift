//
//  RegisterViewController.swift
//  RealTime_iOS_chatApp
//
//  Created by Cumulations Technologies Private Limited on 18/07/22.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    static var customCornerRadius : CGFloat = 10
    let scrollview : UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.clipsToBounds = true
        return scrollview
    }()
    
    let profileImage : UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(systemName: "person.circle")
        profileImage.tintColor = .systemGray
//        profileImage.layer.cornerRadius = profileImage.height/2
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.systemGray.cgColor
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFit
        return profileImage
    }()
    
    let firstNameTextField : UITextField = {
        let firstNameTextField = UITextField()
        firstNameTextField.autocapitalizationType = .words
        firstNameTextField.autocorrectionType = .no
        firstNameTextField.placeholder = "Enter first name"
        firstNameTextField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        firstNameTextField.leftViewMode = .always
        firstNameTextField.returnKeyType = .continue
        firstNameTextField.layer.borderColor = UIColor.systemGray.cgColor
        firstNameTextField.layer.borderWidth = 1
        firstNameTextField.layer.cornerRadius = customCornerRadius
        return firstNameTextField
    }()
    
    let lastNameTextField : UITextField = {
        let lastNameTextField = UITextField()
        lastNameTextField.returnKeyType = .continue
        lastNameTextField.autocorrectionType = .no
        lastNameTextField.autocapitalizationType = .words
        lastNameTextField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        lastNameTextField.leftViewMode = .always
        lastNameTextField.placeholder = "Enter last name"
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.borderColor = UIColor.systemGray.cgColor
        lastNameTextField.layer.cornerRadius = customCornerRadius
        return lastNameTextField
    }()
    
    let emailTextfield : UITextField = {
        let emailTextField = UITextField()
        emailTextField.returnKeyType = .continue
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailTextField.leftViewMode = .always
        emailTextField.placeholder = "Enter email"
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.systemGray.cgColor
        emailTextField.layer.cornerRadius = customCornerRadius
        return emailTextField
    }()
    
    let passwordTextfiled : UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.returnKeyType = .done
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordTextField.leftViewMode = .always
        passwordTextField.placeholder = "Enter password"
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.systemGray.cgColor
        passwordTextField.layer.cornerRadius = customCornerRadius
        return passwordTextField
    }()
    
    let registerButton : UIButton = {
        let registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.backgroundColor = UIColor.systemGreen
        registerButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        registerButton.clipsToBounds = true
        registerButton.layer.cornerRadius = customCornerRadius
        return registerButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        

        //add targets
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        //
//        scrollview.isUserInteractionEnabled = true
        profileImage.isUserInteractionEnabled = true
        
        //delegate
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextfield.delegate = self
        passwordTextfiled.delegate = self
        
        //add subviews
        view.addSubview(scrollview)
        scrollview.addSubview(profileImage)
        scrollview.addSubview(firstNameTextField)
        scrollview.addSubview(lastNameTextField)
        scrollview.addSubview(emailTextfield)
        scrollview.addSubview(passwordTextfiled)
        scrollview.addSubview(registerButton)
        
        //profile image tap gesture
        let gesture = UITapGestureRecognizer(target: self ,action: #selector(tappedProfileImage))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        profileImage.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        
        scrollview.frame = view.bounds
        let size = scrollview.frame.size.width/3
        profileImage.frame = CGRect(x: size, y: scrollview.top + 20, width: size, height: size)
        profileImage.layer.cornerRadius = size/2
        firstNameTextField.frame = CGRect(x: 30, y: profileImage.bottom + 20, width: scrollview.width - 60, height: 52)
        lastNameTextField.frame = CGRect(x: firstNameTextField.left, y: firstNameTextField.bottom + 20, width: firstNameTextField.width, height: firstNameTextField.height)
        emailTextfield.frame = CGRect(x: firstNameTextField.left, y: lastNameTextField.bottom + 20, width: firstNameTextField.width, height: firstNameTextField.height)
        passwordTextfiled.frame = CGRect(x: firstNameTextField.left, y: emailTextfield.bottom + 20, width: firstNameTextField.width, height: firstNameTextField.height)
        registerButton.frame = CGRect(x: firstNameTextField.left + 40, y: passwordTextfiled.bottom + 30, width: firstNameTextField.width - 80, height: firstNameTextField.height)
    }
    
    @objc func registerButtonTapped(){
        
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextfield.resignFirstResponder()
        passwordTextfiled.resignFirstResponder()
        
        guard let firstName = firstNameTextField.text,let lastName = lastNameTextField.text, let email = emailTextfield.text, let password = passwordTextfiled.text , !firstName.isEmpty, !lastName.isEmpty,!email.isEmpty , !password.isEmpty else {
            validateFields()
            return
        }
        
        DatabaseManager.shared.userExists(with: email) {[weak self] exists in
            
            guard let strongSelf = self else{
                return
            }
            guard exists != true else{
//                user already exists
                strongSelf.validateFields(errorMessage: "User Already exists")
                return
            }
        }
//        MARK: - firebase register
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
          
            guard  authResult != nil, error == nil else{
                print("Unable to register user with email\(email), error: \(String(describing: error ?? nil))")
                return
            }
            
//            let user = result.user
//            print("Successfully registered user : \(user) ")
            DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email, password: password))
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc private func tappedProfileImage(){
        print("Heyy..you tapped profile pic")
        profilePicActionSheet()
    }
    
    private func validateFields(errorMessage: String = "Please enter all fields to register."){
        let alert = UIAlertController(title: "Register error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    


}
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField{
            lastNameTextField.becomeFirstResponder()
        }
        else if textField == lastNameTextField{
            emailTextfield.becomeFirstResponder()
        }
        else if textField == emailTextfield{
            passwordTextfiled.becomeFirstResponder()
        }
        else if textField == passwordTextfiled{
            registerButtonTapped()
        }
        return true
    }
}

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func profilePicActionSheet(){
        
        let actionsheet = UIAlertController(title: "Profile Picture", message: "How would you like to choose profile picture?", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionsheet.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { [weak self] _ in
            self?.takePicture()
        }))
        actionsheet.addAction(UIAlertAction(title: "Choose picture", style: .default, handler: { [weak self] _ in
            self?.choosePicture()
        }))
        
        present(actionsheet, animated: true, completion: nil)
        
    }
    
    func takePicture(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func choosePicture(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.profileImage.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
