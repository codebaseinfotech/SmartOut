//
//  HunterDataTVCell.swift
//  SmartOut
//
//  Created by Ankit Gabani on 23/09/25.
//

import UIKit

class HunterDataTVCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFValue: UILabel!
    @IBOutlet weak var lblSValue: UILabel!
    @IBOutlet weak var lblTValue: UILabel!
    @IBOutlet weak var lblFourValue: UILabel!
    
    @IBOutlet weak var viewLineB: UIView!
    @IBOutlet weak var viewFirstData: UIView!
    @IBOutlet weak var viewThirdData: UIView!
    
    @IBOutlet weak var imgBgFirstGradient: UIImageView!
    @IBOutlet weak var imgBgThirdGradient: UIImageView!
    
    private var gradientLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
