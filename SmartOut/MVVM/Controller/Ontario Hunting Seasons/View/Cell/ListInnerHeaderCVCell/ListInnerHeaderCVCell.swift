//
//  ListInnerHeaderCVCell.swift
//  SmartOut
//
//  Created by iMac on 25/09/25.
//

import UIKit

class ListInnerHeaderCVCell: UICollectionViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgDrop: UIImageView!
    
    @IBOutlet weak var viewTopLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgDrop.transform = .identity
        // Initialization code
    }

}
