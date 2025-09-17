//
//  HunterReportingTblViewCell.swift
//  SmartOut
//
//  Created by iMac on 15/09/25.
//

import UIKit
import Charts
import DGCharts

class HunterReportingTblViewCell: UITableViewCell {

    @IBOutlet weak var imgAnimal: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSpringChart: UIView!
    @IBOutlet weak var viewFallChart: UIView!
    @IBOutlet weak var view3ValueChart: UIView!
    
    @IBOutlet weak var lblFChartName: UILabel!
    @IBOutlet weak var lblSChartName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
