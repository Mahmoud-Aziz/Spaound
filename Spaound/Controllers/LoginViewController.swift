
import UIKit
import FirebaseAuth
import FBSDKLoginKit
import JGProgressHUD


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
        
        view.addSubview(facebookLoginButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emailTextField.layer.cornerRadius = 16.0
        passwordTextField.layer.cornerRadius = 16.0
        loginButton.layer.cornerRadius = 16.0
        facebookLoginButton.frame = CGRect(x: 32, y: 740, width:360 , height: 55)
        
    }
    
    
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
            
            let user = results.user
            print("auth is \(authResult!)")
            print("logged in user with\(user)")
            
            DispatchQueue.main.async {
                self?.spinner.dismiss()
            }
            
            let vc = TabBarViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        
    }
    
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
                  let pictureURL = data["url"] as? String, let url = data["url"] else {
                print("Failed to get email and name from the result")
                return
            }
            
            print(result)
            
            UserDatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    
                    UserDatabaseManager.shared.insertUser(with: SpaoundUser(firstName: firstName, lastName: lastName, emailAddress: email, phoneNumber: nil))
                    
                    let spaoundUser = SpaoundUser(firstName: firstName , lastName: lastName, emailAddress: email, phoneNumber: 0)
                    UserDefaults.standard.setValue(url, forKey: "url")
                    
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
                        
                        let fileName = spaoundUser.profilePicturUrl
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                            switch result {
                            
                            case .success(let downloadUrl):
                                
                                UserDefaults.standard.setValue(downloadUrl, forKey: "profile_picture_url")
                                
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
            
                let vc = TabBarViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
                
            })
        })
        
        
    }
    
}
