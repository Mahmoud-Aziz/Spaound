//
//  CustomCellTableView.swift
//  Spaound
//
//  Created by Mahmoud Aziz on 07/03/2021.
//

import UIKit

class CustomCellTableView: UITableViewCell {
    
    @IBOutlet weak var spaceNameLabel:UILabel!
    @IBOutlet weak var spaceAddressLabel:UILabel!
    @IBOutlet weak var spacePriceLabel:UILabel! 

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let spaceName = UserDefaults.standard.value(forKey: "space_name") as? String
        let spaceAddress = UserDefaults.standard.value(forKey: "space_district") as? String
        let spacePrice = UserDefaults.standard.value(forKey: "price_per_day") as? Int
        
        spaceNameLabel.text = spaceName
        spaceAddressLabel.text = spaceAddress
        spacePriceLabel.text = String(spacePrice ?? 0)
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
