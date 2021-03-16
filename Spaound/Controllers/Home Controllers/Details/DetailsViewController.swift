
import UIKit

class DetailsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func backButtonPressed( _ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    



}
