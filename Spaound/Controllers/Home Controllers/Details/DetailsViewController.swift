
import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet private weak var priceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        priceView.layer.cornerRadius = 16.0
    }




}
