

import UIKit

class TableViewCustomCell: UITableViewCell {

    @IBOutlet private weak var spaceNameLabel:UILabel!
    @IBOutlet private weak var spaceAddressLabel:UILabel!
    @IBOutlet private weak var spacePriceLabel:UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()


    }
    
    
    func configureCell(space:SpaceInfo) {

        spaceNameLabel.text = space.name
        spaceAddressLabel.text = space.spaceDistrict
        spacePriceLabel.text = String(space.pricePerDay)
    }

   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
