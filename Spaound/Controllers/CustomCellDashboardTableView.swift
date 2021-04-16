//
//  CustomCellDashboardTableView.swift
//  Spaound
//
//  Created by Mahmoud Aziz on 13/03/2021.
//

import UIKit

class CustomCellDashboardTableView: UITableViewCell {
    
    @IBOutlet weak var spaceNameLabel:UILabel!
    @IBOutlet weak var spaceAddressLabel:UILabel!
    @IBOutlet weak var spacePriceLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

   
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
