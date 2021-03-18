
import UIKit
import FirebaseAuth
import JGProgressHUD
import PhoneNumberKit

class RegisterViewController: UIViewController {

    @IBOutlet private weak var firstNameTextField:UITextField!
    @IBOutlet private weak var lastNameTextField:UITextField!
    @IBOutlet private weak var emailTextField:UITextField!
    @IBOutlet private weak var phoneNumberTextField:PhoneNumberTextField!
    @IBOutlet private weak var passwordTextField:UITextField!
    @IBOutlet private weak var continueButton:UIButton! 
    
    var currentVerificationId = ""
    private let spinner = JGProgressHUD(style: .dark)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboard()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        phoneNumberTextField.withFlag = true
        phoneNumberTextField.withPrefix = true
        phoneNumberTextField.withExamplePlaceholder = true
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "+20 100 230 33 56")
      
        phoneNumberTextField.text = PartialFormatter(phoneNumberKit: PhoneNumberKit(), defaultRegion: "EG", withPrefix: true, maxDigits: 13).formatPartial("+20")
        
        phoneNumberTextField.withDefaultPickerUI = true

    }
    
   


 
    //MARK:- Continue to phone verfication
    
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
    
   
}

class MyGBTextField: PhoneNumberTextField {
    override var defaultRegion: String {
        get {
            return "EG"
        }
        set {}
    }

}

  let ref = MyGBTextField()

