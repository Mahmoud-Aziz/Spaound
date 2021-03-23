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
       
        
      
    }
    
    let spaces = UserDefaults.standard.value(forKey: "spaces") as? [[String:Any]] ?? [[:]]
    
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

    }
    
}
