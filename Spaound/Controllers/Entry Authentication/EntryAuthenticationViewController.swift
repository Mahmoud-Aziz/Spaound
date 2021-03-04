
import UIKit

class EntryAuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
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
