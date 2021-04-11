

import Foundation
import FirebaseDatabase

class CustomCellCollectionView: UICollectionViewCell {
    
    @IBOutlet weak private var spaceNameLabel:UILabel!
    @IBOutlet weak private var priceLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    let spaces = UserDefaults.standard.value(forKey: "spaces") as? [[String:Any]]
    
    func configureCell(indexpath:IndexPath) {
        
        let spaceName = spaces?[indexpath.row]["name"] as? String
        let spacePrice = spaces?[indexpath.row]["pricePerDay"] as? Int

        spaceNameLabel.text = spaceName
        priceLabel.text = String(spacePrice ?? 0)
    }

    
}
