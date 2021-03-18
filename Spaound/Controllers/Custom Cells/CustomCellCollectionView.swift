

import Foundation
import FirebaseDatabase

class CustomCellCollectionView: UICollectionViewCell {
    

    @IBOutlet weak private var spaceNameLabel:UILabel!
    @IBOutlet weak private var priceLabel:UILabel!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let price = UserDefaults.standard.value(forKey: "price_per_day") as? Int
        spaceNameLabel.text = UserDefaults.standard.value(forKey: "space_name") as? String
        priceLabel.text = String(price ?? 000)
        
        
    }

    

    
}
