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
        
        SpacesDatabaseManager.shared.retrieveSpace(with: "spaceTwo", completion: { [weak self] space in
            self?.spaceNameLabel.text = space.spaceName
            self?.spaceAddressLabel.text = space.spaceDistrict
            self?.spacePriceLabel.text = (String(space.pricePerDay))
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
