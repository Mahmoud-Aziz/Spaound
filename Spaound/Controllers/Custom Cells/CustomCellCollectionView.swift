

import Foundation
import FirebaseDatabase

class CustomCellCollectionView: UICollectionViewCell {
    

    @IBOutlet weak private var spaceNameLabel:UILabel!
    @IBOutlet weak private var priceLabel:UILabel!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        spaceNameLabel.text = UserDefaults.standard.value(forKey: "space_name") as? String
        priceLabel.text = UserDefaults.standard.value(forKey: "space_price_per_day") as? String
    }

    

    
}
