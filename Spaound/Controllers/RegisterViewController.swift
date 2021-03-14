
import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet private weak var firstNameTextField:UITextField!
    @IBOutlet private weak var lastNameTextField:UITextField!
    @IBOutlet private weak var emailTextField:UITextField!
    @IBOutlet private weak var phoneNumberTextField:UITextField!
    @IBOutlet private weak var passwordTextField:UITextField!
    @IBOutlet private weak var continueButton:UIButton! 
    
    var currentVerificationId = ""
    private let spinner = JGProgressHUD(style: .dark)

    
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
              let userPhoneNumber = Int(phoneNumberTextField.text!),
              let password = passwordTextField.text,
              !email.isEmpty,!password.isEmpty,
              !firstName.isEmpty,!lastName.isEmpty,
              password.count >= 6 else {
            
            alertUserRegisterError()
            return
        }
        
        spinner.show(in: view)

            //firebase login
            
        UserDatabaseManager.shared.userExists(with: email, completion: {[weak self] exists in
            
            guard !exists else {
                //user already exists
                self?.alertUserRegisterError(with: "User already exist, Try to log In instead.")
                self?.spinner.dismiss()
                return
            }
            
         Auth.auth().languageCode = "en";
       
            let phoneNumber = self?.phoneNumberTextField.text
         
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil, completion: { [self]verficationID, error in
             
            print("code sent")
            
             guard let verificationID = verficationID, error == nil else {
                print(error?.localizedDescription as Any)
                 return
             }
             
             self?.currentVerificationId = verificationID
             
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")


            let vc = PhoneVerificationViewController()
                
                vc.emailFromRegister = email
                vc.firstNameFromRegister = firstName
                vc.lastNameFromRegister = lastName
                vc.passwordFromRegister = password
                vc.phoneFromRegister = userPhoneNumber
                
                DispatchQueue.main.async {
                    self?.spinner.dismiss()
                    
                }
                
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
    
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if (phoneNumberTextField.text?.rangeOfCharacter(from: NSCharacterSet.decimalDigits)) != nil {
//            return true
//        } else {
//            return false
//        }
//    }
    
}

