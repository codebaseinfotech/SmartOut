//
//  ListDetailsTblViewCell.swift
//  SmartOut
//
//  Created by iMac on 16/09/25.
//

import UIKit

class ListDetailsTblViewCell: UITableViewCell {
    
    @IBOutlet weak var lblwmu: UILabel!
    
    @IBOutlet weak var viewRifle: UIView!
    @IBOutlet weak var viewShortgun: UIView!
    @IBOutlet weak var viewMuzzleLoader: UIView!
    @IBOutlet weak var viewBow: UIView!
    
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var lblConditionS: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
