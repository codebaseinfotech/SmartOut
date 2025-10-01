//
//  ExceptionsDetailsCVCell.swift
//  SmartOut
//
//  Created by iMac on 01/10/25.
//

import UIKit

class ExceptionsDetailsCVCell: UICollectionViewCell {

    @IBOutlet weak var viewMainAdditionalOppo: UIView!
    @IBOutlet weak var viewMainSeason: UIView!
    @IBOutlet weak var viewMainLimits: UIView!
    @IBOutlet weak var viewMainDis: UIView!
    
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var lblLimits: UILabel!
    @IBOutlet weak var lblDis: UILabel!
    
    @IBOutlet weak var imgDisLocation: UIImageView!
    @IBOutlet weak var imgSeasonLocation: UIImageView!
    
    
    @IBOutlet weak var viewBottomLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
