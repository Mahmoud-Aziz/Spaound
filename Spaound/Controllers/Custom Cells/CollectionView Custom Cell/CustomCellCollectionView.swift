

import Foundation
import FirebaseDatabase

class CustomCellCollectionView: UICollectionViewCell {
    
    @IBOutlet weak private var spaceNameLabel:UILabel!
    @IBOutlet weak private var priceLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(space:SpaceInfo) {

        spaceNameLabel.text = space.name
        priceLabel.text = String(space.pricePerDay)
    }

    
}
