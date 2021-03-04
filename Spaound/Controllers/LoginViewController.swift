
import UIKit
import FirebaseAuth
import FBSDKLoginKit


class LoginViewController: UIViewController {
    
    private let facebookLoginButton: FBLoginButton = {
        
        let button = FBLoginButton()
        button.layer.cornerRadius = 16.0
        button.clipsToBounds = true
        button.setTitle("Continue with Facebook", for: .normal)
        //        button.titleLabel?.adjustsFontForContentSizeCategory = (UIFont(name: "Avenir Roman", size: 20.0) != nil)
        button.permissions = ["email","public_profile"]
        return button
        
    }()
    
    
    @IBOutlet private var emailTextField:UITextField!
    @IBOutlet private var passwordTextField:UITextField! 
    @IBOutlet private var loginButton:UIButton!
    @IBOutlet private var resetPassword:UIButton!
    
    
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
        //firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult,error in
            guard let results = authResult, error == nil else {
                print("failed to log user in with email: \(email)")
                return
            }
            let user = results.user
            print("logged in user with\(user)")
            
            let vc = HomeViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        
    }
    
    func alertUserLoginError() {
        
        let alert = UIAlertController(title: "Warning", message: "Please complete all required info.", preferredStyle: .alert)
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
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"], tokenString: token, version: nil, httpMethod: .get)
        
        facebookRequest.start(completionHandler: {_, result, error in
            guard let result = result as? [String:Any], error == nil else {
                print("failed to make facebook graph request")
                return
            }
            
            print("\(result)")
            
            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String else {
                print("Failed to get email and name from the result")
                return
            }
            
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else {
                return
            }
            
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    
                    DatabaseManager.shared.insertUser(with: SpaoundUser(firstName: firstName, lastName: lastName, emailAddress: email, phoneNumber: nil))
                }
            })
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult,error in
                
                guard authResult != nil, error == nil else {
                    
                    print("Facebook credential login failed, MFA may be needed")
                    return
                }
                print("Successfully logged user in")
                
                let vc = HomeViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        })
        
        
    }
    
}
