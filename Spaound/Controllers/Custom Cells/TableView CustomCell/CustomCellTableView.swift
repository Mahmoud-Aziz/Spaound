

import UIKit
import Cosmos

class CustomCellTableView: UITableViewCell {
    
    @IBOutlet weak var spaceNameLabel:UILabel!
    @IBOutlet weak var spaceAddressLabel:UILabel!
    @IBOutlet weak var spacePriceLabel:UILabel! 
    @IBOutlet var cosmosView: CosmosView!
    var settings = CosmosSettings()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        settings.updateOnTouch = true
        settings.passTouchesToSuperview = true
    }
    
    func configureCell(space:SpaceInfo) {
        spaceNameLabel.text = space.name
        spaceAddressLabel.text = space.spaceDistrict
        spacePriceLabel.text = String(space.pricePerDay)

    }
    
    func update(_ rating: Double) {
      cosmosView.rating = rating
      
    }
    
    override public func prepareForReuse() {
      cosmosView.prepareForReuse()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
