
import UIKit
import FirebaseAuth


class PhoneVerificationViewController: UIViewController {
    
    @IBOutlet private var sentCodeTextField:UITextField!
    
    
    var emailFromRegister = ""
    var passwordFromRegister = ""
    var firstNameFromRegister = ""
    var lastNameFromRegister = ""
    var phoneFromRegister:Int = 0
    var verificationIDfromRegister = ""
    
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction private func createYourAccountButtonTapped(_ sender:UIButton) {
        
        guard sentCodeTextField.text != nil else {
            print("sent code field empty")
            return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: emailFromRegister, password: passwordFromRegister, completion: { authResult,error in
            guard authResult != nil, error == nil else {
                print("error creating user")
                return
            }
            
            DatabaseManager.shared.insertUser(with: SpaoundUser(firstName: self.firstNameFromRegister, lastName:self.lastNameFromRegister, emailAddress: self.emailFromRegister, phoneNumber: self.phoneFromRegister))
            
            let vc = HomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        })
    }
}



