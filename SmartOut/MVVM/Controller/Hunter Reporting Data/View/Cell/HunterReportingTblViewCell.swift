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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let entries1 = [PieChartDataEntry(value: 80.0, label: "Female"),
                       PieChartDataEntry(value: 20.0, label: "Male")]
        PieChart.shared.setupChart(view: viewSpringChart, entries: entries1, colors: [.systemBlue, .orange])
        
        
        let entries2 = [PieChartDataEntry(value: 37.0, label: "Female"),
                       PieChartDataEntry(value: 63.0, label: "Male")]
        PieChart.shared.setupChart(view: viewFallChart, entries: entries2, colors: [.systemBlue, .orange])
        
        let entries3 = [PieChartDataEntry(value: 27.0, label: "BUll"),
                        PieChartDataEntry(value: 14.3, label: "Cow"),
                        PieChartDataEntry(value: 58.7, label: "Calf")]
        PieChart.shared.setupChart(view: view3ValueChart, entries: entries3, colors: [.systemBlue, .orange, .yellow])
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
