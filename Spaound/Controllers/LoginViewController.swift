
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet private var emailTextField:UITextField!
    @IBOutlet private var passwordTextField:UITextField! 
    @IBOutlet private var loginButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

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
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {authResult,error in
            guard let results = authResult, error == nil else {
                print("failed to log user in with email: \(email)")
                return
            }
            let user = results.user
            print("logged in user with\(user)")
        })
        let vc = HomeViewController()
        navigationController?.pushViewController(vc, animated: true)
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
