//
//  ZoneWideTblViewCell.swift
//  SmartOut
//
//  Created by iMac on 16/09/25.
//

import UIKit

class ZoneWideTblViewCell: UITableViewCell {

    @IBOutlet weak var lblFish: UILabel!
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var lblLimit: UILabel!
    
    @IBOutlet weak var viewMainSeason: UIView!
    @IBOutlet weak var viewLimitsMain: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
