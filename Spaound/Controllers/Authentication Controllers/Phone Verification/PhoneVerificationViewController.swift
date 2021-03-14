
import UIKit
import FirebaseAuth
import JGProgressHUD

class PhoneVerificationViewController: UIViewController {
    
    @IBOutlet private weak var sentCodeTextField:UITextField!
    
    
    var emailFromRegister = ""
    var passwordFromRegister = ""
    var firstNameFromRegister = ""
    var lastNameFromRegister = ""
    var phoneFromRegister:Int = 0
    var verificationIDfromRegister = ""
    
    private let spinner = JGProgressHUD(style: .dark)

    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func alertCodeError(with message:String = "Please enter the code that was sent to your mobile number.") {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func createYourAccountButtonTapped(_ sender:UIButton) {
        
        sentCodeTextField.resignFirstResponder()
        
        guard sentCodeTextField.text != nil else {
            alertCodeError()
            return
        }
        spinner.show(in: view)

        FirebaseAuth.Auth.auth().createUser(withEmail: emailFromRegister, password: passwordFromRegister, completion: { authResult,error in
            guard authResult != nil, error == nil else {
                print("error creating user")
                return
            }
            UserDatabaseManager.shared.insertUser(with: SpaoundUser(firstName: self.firstNameFromRegister, lastName:self.lastNameFromRegister, emailAddress: self.emailFromRegister, phoneNumber: self.phoneFromRegister))
            
            
            UserDefaults.standard.setValue(self.firstNameFromRegister, forKey: "first_name")
            UserDefaults.standard.setValue(self.lastNameFromRegister, forKey: "last_name")
            UserDefaults.standard.setValue(self.phoneFromRegister, forKey: "phone_number")
            
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
            let vc = TabBarViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        })
    }
}

extension PhoneVerificationViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (sentCodeTextField.text?.rangeOfCharacter(from: NSCharacterSet.decimalDigits)) != nil {
            return true
        } else {
            return false
        }
    }
}



