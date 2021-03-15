
import UIKit

class EntryAuthenticationViewController: UIViewController {

    @IBOutlet private weak var loginButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if !UserDefaults.standard.bool(forKey: "didSee") {
            
            UserDefaults.standard.set(true, forKey: "didSee")
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(identifier: "OnboardingViewController") as? OnboardingViewController
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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

