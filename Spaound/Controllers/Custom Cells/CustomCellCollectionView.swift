

import Foundation
import FirebaseDatabase

class CustomCellCollectionView: UICollectionViewCell {
    

    @IBOutlet weak private var spaceNameLabel:UILabel!
    @IBOutlet weak private var priceLabel:UILabel!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        SpacesDatabaseManager.shared.retrieveSpace(with: "spaceOne", completion: { [weak self] space in
            self?.spaceNameLabel.text = space.spaceName
            self?.priceLabel.text = "L.E \(space.pricePerDay)"
        })
    }

    

    
}
