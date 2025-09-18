//
//  DataTableCollectionViewCell.swift
//  SmartOut
//
//  Created by iMac on 18/09/25.
//

import UIKit

class DataTableCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue1: UILabel!
    @IBOutlet weak var lblValue2: UILabel!
    @IBOutlet weak var lblValue3: UILabel!
    @IBOutlet weak var lblValue4: UILabel!
    
    @IBOutlet weak var viewBottomLine: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
