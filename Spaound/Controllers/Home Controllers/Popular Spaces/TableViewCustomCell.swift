

import UIKit

class TableViewCustomCell: UITableViewCell {

    @IBOutlet private weak var spaceNameLabel:UILabel!
    @IBOutlet private weak var spaceAddressLabel:UILabel!
    @IBOutlet private weak var spacePriceLabel:UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let spaceName = UserDefaults.standard.value(forKey: "space_name") as? String
        let spaceAddress = UserDefaults.standard.value(forKey: "space_address") as? String
        let spacePrice = UserDefaults.standard.value(forKey: "space_price_per_day") as? Int
        
        spaceNameLabel.text = spaceName
        spaceAddressLabel.text = spaceAddress
        spacePriceLabel.text = String(spacePrice ?? 0)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
