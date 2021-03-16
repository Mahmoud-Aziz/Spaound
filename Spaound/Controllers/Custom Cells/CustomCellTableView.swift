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

        spaceNameLabel.text = UserDefaults.standard.value(forKey: "space_name") as? String
        spaceAddressLabel.text = UserDefaults.standard.value(forKey: "space_address") as? String
        spacePriceLabel.text = UserDefaults.standard.value(forKey: "space_price_per_day") as? String
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
