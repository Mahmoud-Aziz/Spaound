
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
    
    @IBAction private func continueButtonTapped(_ sender:UIButton) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let phone = phoneNumberTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,!password.isEmpty,
              !firstName.isEmpty,!lastName.isEmpty, !phone.isEmpty,password.count >= 6 else {
            
            alertUserRegisterError()
            return
        }
            //firebase login
            
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] authResult,error in
            guard let result = authResult, error == nil else {
                print("error creating user")
                return
            }
            let user = result.user
            print("created user \(user)")
        })
        let vc = PhoneVerificationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func alertUserRegisterError() {
        
        let alert = UIAlertController(title: "Warning", message: "Please complete all required info.", preferredStyle: .alert)
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
