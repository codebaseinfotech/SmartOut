//
//  ListDetailsCVCell.swift
//  SmartOut
//
//  Created by iMac on 25/09/25.
//

import UIKit

class ListDetailsCVCell: UICollectionViewCell {

    @IBOutlet weak var viewMainRifle: UIView!
    @IBOutlet weak var viewMainShotgun: UIView!
    @IBOutlet weak var viewMainMuzzleloader: UIView!
    @IBOutlet weak var viewMainBow: UIView!
    @IBOutlet weak var viewMainWMUs: UIView!
    @IBOutlet weak var viewMainSeason: UIView!
    @IBOutlet weak var viewMainConditions: UIView!
    
    @IBOutlet weak var lblWMUs: UILabel!
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var lblConditions: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
