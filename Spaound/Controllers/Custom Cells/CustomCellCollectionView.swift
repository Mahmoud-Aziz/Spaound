

import Foundation
import FirebaseDatabase

class CustomCellCollectionView: UICollectionViewCell {
    

    @IBOutlet weak private var spaceNameLabel:UILabel!
    @IBOutlet weak private var priceLabel:UILabel!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    func configureCell() {
        
        let spacePrice = UserDefaults.standard.value(forKey: "price_per_day") as? Int
        let spaceName = UserDefaults.standard.value(forKey: "space_name") as? String
        priceLabel.text = String(spacePrice ?? 000)
        spaceNameLabel.text = spaceName
    }

    
}
