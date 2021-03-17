
import UIKit
import FirebaseAuth
import JGProgressHUD

class PhoneVerificationViewController: UIViewController {
    
    @IBOutlet private weak var sentCodeTextField:UITextField!
    @IBOutlet private weak var createYourAccountButton:UIButton!

    
    
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
    
    //MARK:- Create new account 
    
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
            
            SpacesDatabaseManager.shared.retrieveSpace(completion: { space in
                
                UserDefaults.standard.setValue(space.spaceName, forKey: "space_name")
                UserDefaults.standard.setValue(space.spaceDistrict, forKey: "space_district")
                UserDefaults.standard.setValue(space.spaceStreetName, forKey: "space_street")
                UserDefaults.standard.setValue(space.freeWiFi, forKey: "free_wifi")
                UserDefaults.standard.setValue(space.booksLibrary, forKey: "books_library")
                UserDefaults.standard.setValue(space.coffee, forKey: "coffee")
                UserDefaults.standard.setValue(space.meetingRoom, forKey: "meeting_room")
                UserDefaults.standard.setValue(space.gamingRoom, forKey: "gamingRoom")
                UserDefaults.standard.setValue(space.aboutSpace, forKey: "about_space")
                UserDefaults.standard.setValue(space.pricePerDay, forKey: "price_per_day")
                UserDefaults.standard.setValue(space.pricePerDayMeetingRoom, forKey: "price_meeting")
                UserDefaults.standard.setValue(space.pricePerDaySmallRoom, forKey: "price_small")
                UserDefaults.standard.setValue(space.pricePerDayGamesRoom, forKey: "price_games")
                UserDefaults.standard.setValue(space.pricePerDaySharedSpace, forKey: "price_shared")
                UserDefaults.standard.setValue(space.facebookLink, forKey: "facebook")
                UserDefaults.standard.setValue(space.whatsAppNumber, forKey: "whatsapp")
                UserDefaults.standard.setValue(space.contactNumber, forKey: "contact_number")


            })
            
            UserDatabaseManager.shared.insertUser(with: SpaoundUser(firstName: self.firstNameFromRegister, lastName:self.lastNameFromRegister, emailAddress: self.emailFromRegister, phoneNumber: self.phoneFromRegister))
            
            
            UserDefaults.standard.setValue(self.firstNameFromRegister, forKey: "first_name")
            UserDefaults.standard.setValue(self.lastNameFromRegister, forKey: "last_name")
            UserDefaults.standard.setValue(self.phoneFromRegister, forKey: "phone_number")
            
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
                        
            let vc = HomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        })
    }
}

extension PhoneVerificationViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == sentCodeTextField {
            createYourAccountButtonTapped(createYourAccountButton)
        }
        return true 
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (sentCodeTextField.text?.rangeOfCharacter(from: NSCharacterSet.decimalDigits)) != nil {
            return true
        } else {
            return false
        }
    }
}



