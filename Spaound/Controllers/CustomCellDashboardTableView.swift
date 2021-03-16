//
//  CustomCellDashboardTableView.swift
//  Spaound
//
//  Created by Mahmoud Aziz on 13/03/2021.
//

import UIKit

class CustomCellDashboardTableView: UITableViewCell {
    
    @IBOutlet weak var spaceNameLabel:UILabel! 
    static let shared = CustomCellDashboardTableView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
