

import UIKit

class TableViewCustomCell: UITableViewCell {

    @IBOutlet private weak var spaceNameLabel:UILabel!
    @IBOutlet private weak var spaceAddressLabel:UILabel!
    @IBOutlet private weak var spacePriceLabel:UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()


    }
    
    let spaces = UserDefaults.standard.value(forKey: "spaces") as! [[String:Any]]
    
    func configureCell(indexpath:IndexPath) {
        
        let spaceName = spaces[indexpath.row]["name"] as! String
        let spaceAddress = spaces[indexpath.row]["spaceDistrict"] as! String
        let spacePrice = spaces[indexpath.row]["pricePerDay"] as! Int

        spaceNameLabel.text = spaceName
        spaceAddressLabel.text = spaceAddress
        spacePriceLabel.text = String(spacePrice)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
