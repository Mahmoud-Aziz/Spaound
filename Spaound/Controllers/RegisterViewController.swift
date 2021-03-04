
import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet private var firstNameTextField:UITextField!
    @IBOutlet private var lastNameTextField:UITextField!
    @IBOutlet private var emailTextField:UITextField!
    @IBOutlet private var phoneNumberTextField:UITextField!
    @IBOutlet private var passwordTextField:UITextField!
    @IBOutlet private var continueButton:UIButton! 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        firstNameTextField.layer.cornerRadius = 16.0
        lastNameTextField.layer.cornerRadius = 16.0
        emailTextField.layer.cornerRadius = 16.0
        phoneNumberTextField.layer.cornerRadius = 16.0
        passwordTextField.layer.cornerRadius = 16.0
        continueButton.layer.cornerRadius = 16.0
    }
    
    @IBAction private func continueButtonTapped(_ sender:UIButton) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        
        //can't guard phone number is not empty cause it's int
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let phone = Int(phoneNumberTextField.text!),
              let password = passwordTextField.text,
              !email.isEmpty,!password.isEmpty,
              !firstName.isEmpty,!lastName.isEmpty,
              password.count >= 6 else {
            
            alertUserRegisterError()
            return
        }
            //firebase login
            
        DatabaseManager.shared.userExists(with: email, completion: {[weak self] exists in
            guard !exists else {
                //user already exists
                self?.alertUserRegisterError(with: "User already exist, Try to log In instead.")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] authResult,error in
                guard authResult != nil, error == nil else {
                    print("error creating user")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: SpaoundUser(firstName: firstName, lastName: lastName, emailAddress: email, phoneNumber: phone))
                
                let vc = PhoneVerificationViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        })
 
    }
    
    func alertUserRegisterError(with message:String = "Please complete all required info.") {
        
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
        
       
    }

extension RegisterViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            phoneNumberTextField.becomeFirstResponder()
        } else if textField == phoneNumberTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            continueButtonTapped(continueButton)
        }
        return true
    }
    
}
