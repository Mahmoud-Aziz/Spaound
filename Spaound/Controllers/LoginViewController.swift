
import UIKit
import FirebaseAuth
import FBSDKLoginKit
import JGProgressHUD
import FirebaseDatabase
import Kingfisher

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let facebookLoginButton: FBLoginButton = {
        
        let button = FBLoginButton()
        button.layer.cornerRadius = 16.0
        button.clipsToBounds = true
        button.setTitle("Continue with Facebook", for: .normal)
        //        button.titleLabel?.adjustsFontForContentSizeCategory = (UIFont(name: "Avenir Roman", size: 20.0) != nil)
        button.permissions = ["email","public_profile"]
        return button
        
    }()
    
    @IBOutlet private weak var emailTextField:UITextField!
    @IBOutlet private weak var passwordTextField:UITextField!
    @IBOutlet private weak var loginButton:UIButton!
    
    @IBOutlet private weak var resetPassword:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        facebookLoginButton.delegate = self
        self.dismissKeyboard()
        view.addSubview(facebookLoginButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        facebookLoginButton.frame = CGRect(x: 32, y: 700, width: loginButton.frame.width , height: loginButton.frame.height)
        
    }
    
    //MARK:- Login
    
    @IBAction private func loginButtonTapped(_ sender:UIButton) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        spinner.show(in: view)
        spinner.textLabel.text = "Loading"
        
        //firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult,error in
            
            guard let results = authResult, error == nil else {
                self?.alertUserLoginError(title: "Warning", message: "Please enter valid mail and password")
                
                DispatchQueue.main.async {
                    self?.spinner.dismiss()
                }
                
                print("failed to log user in with email: \(email)")
                return
            }
            
            UserDefaults.standard.setValue(email, forKey: "email")
            
            let user = results.user
            print("logged in user with\(user)")
            
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
            
            var safeEmail = email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            
            let database = Database.database().reference()
            database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value as? [String:Any] else {
                    return
                }
                
                var user = UserInfo()
                user.firstName = value["first_name"] as! String
                user.lastName = value["last_name"] as! String
                user.phoneNumber = value["phone_number"] as! Int
                
                UserDefaults.standard.setValue(user.firstName, forKey: "first_name")
                UserDefaults.standard.setValue(user.lastName, forKey: "last_name")
                UserDefaults.standard.setValue(user.phoneNumber, forKey: "phone_number")
            })
            
            DispatchQueue.main.async {
                self?.spinner.dismiss()
            }
            
            let vc = TabBarViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        
    }
    
    //MARK:- Reset Password
    
    @IBAction private func resetPasswordButtonTapped(_sender:UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            alertUserLoginError(message: "Please enter your email.")
            return
        }
        
        UserDatabaseManager.shared.userExists(with:email, completion: { [weak self] exists in
            
            guard !exists else {
                //user doesn't exists
                self?.alertUserLoginError(title: "Warning", message: "Email is't registered, Please sign up")
                return
            }
            
            self?.resetPassword(email: email, onSuccess: {
                self?.alertUserLoginError(title: "", message: "Password reset email is sent to your email.")
            }, onError: {[weak self] _ in
                self?.alertUserLoginError(message: "Email is't registered, Please sign up")
            })
            
        })
        
        
        
    }
    
    func resetPassword(email:String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: {error in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
        })
    }
    
    func alertUserLoginError(title:String = "Warning" ,message:String = "Please complete all required info.") {
        
        let alert = UIAlertController(title:title, message:message , preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension LoginViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButtonTapped(loginButton)
        }
        return true
    }
}

//MARK:- Facebook login

extension LoginViewController: LoginButtonDelegate {
    
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //no operation, won't use fb button to log out
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("user failed to login with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, first_name, last_name,picture.type(large)"], tokenString: token, version: nil, httpMethod: .get)
        
        facebookRequest.start(completionHandler: {_, result, error in
            guard let result = result as? [String:Any], error == nil else {
                print("failed to make facebook graph request")
                return
            }
            
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String,
                  let email = result["email"] as? String, let picture = result["picture"] as? [String:Any],
                  let data = picture["data"] as? [String:Any],
                  let pictureURL = data["url"] as? String else {
                print("Failed to get email and name from the result")
                return
            }
            
            print(result)
            
            UserDatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    
                    UserDatabaseManager.shared.insertUser(with: SpaoundUser(firstName: firstName, lastName: lastName, emailAddress: email, phoneNumber: nil))
                    
                    guard let url = URL(string: pictureURL) else {
                        return
                    }
                    
                    print("downloading data from facebook image")
                    
                    URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                        guard let data = data else {
                            print("failed to get data from faecbook ")
                            return
                        }
                        
                        print("got data from facebook, uploading")
                        
                        let email = UserDefaults.standard.value(forKey: "email") as? String
                        var safeEmail = email?.replacingOccurrences(of: ".", with: "-")
                        safeEmail = safeEmail?.replacingOccurrences(of: "@", with: "-")
                        
                        let fileName = "\(safeEmail ?? "")_profile_picture.png"
                        
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                            switch result {
                            
                            case .success(let downloadUrl):
                                
                                UserDefaults.standard.removeObject(forKey: "profile_picture_url")
                                UserDefaults.standard.setValue(downloadUrl, forKey:"profile_picture_url")
                                
                            case .failure(let error):
                                
                                print("storage manager error: \(error)")
                            }
                        })
                    }).resume()
                }
            })
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult,error in
                
                guard authResult != nil, error == nil else {
                    
                    print("Facebook credential login failed, MFA may be needed")
                    return
                }
                
                print("Successfully logged user in")
                
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
                    UserDefaults.standard.setValue(space.pricePerDayMeetingRoom, forKey:"price_meeting")
                    UserDefaults.standard.setValue(space.pricePerDaySmallRoom, forKey: "price_small")
                    UserDefaults.standard.setValue(space.pricePerDayGamesRoom, forKey: "price_games")
                    UserDefaults.standard.setValue(space.pricePerDaySharedSpace, forKey: "price_shared")
                    UserDefaults.standard.setValue(space.facebookLink, forKey: "facebook")
                    UserDefaults.standard.setValue(space.whatsAppNumber, forKey: "whatsapp")
                    UserDefaults.standard.setValue(space.contactNumber, forKey: "contact_number")

                })
                
                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.setValue(firstName, forKey: "first_name")
                UserDefaults.standard.setValue(lastName, forKey: "last_name")
                UserDefaults.standard.setValue(true, forKey: "fb_signed")
                
                let vc = TabBarViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
                
            })
        })
        
        
    }
    
}
