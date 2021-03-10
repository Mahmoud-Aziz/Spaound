
import UIKit

class EntryAuthenticationViewController: UIViewController {

    @IBOutlet private weak var loginButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        loginButton.layer.cornerRadius = 16.0

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: true)

    }
    
    @IBAction private func loginButtonTapped(_ sender:UIButton) {
        
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func registerButtonTapped(_ sender:UIButton) {
        
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


}
