//
//  HunterReportingTblViewCell.swift
//  SmartOut
//
//  Created by iMac on 15/09/25.
//

import UIKit
import Charts
import DGCharts


protocol reloadCell: AnyObject {
    func reloadData()
}

class HunterReportingTblViewCell: UITableViewCell {

    @IBOutlet weak var imgAnimal: UIImageView! {
        didSet {
            imgAnimal.tintColor = .primary
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSpringChart: UIView!
    @IBOutlet weak var viewFallChart: UIView!
    @IBOutlet weak var view3ValueChart: UIView!
    
    @IBOutlet weak var lblFChartName: UILabel!
    @IBOutlet weak var lblSChartName: UILabel!
        
    @IBOutlet weak var viewMainChart: UIView!
    @IBOutlet weak var viewMainCharS: UIView!
    
    
    @IBOutlet weak var lblBull: UILabel!
    @IBOutlet weak var lblCow: UILabel!
    @IBOutlet weak var lblCalf: UILabel!
    
    @IBOutlet weak var lblBullValue: UILabel!
    @IBOutlet weak var lblCowValue: UILabel!
    @IBOutlet weak var lblCalfValue: UILabel!
    
    @IBOutlet weak var viewClaf: UIView!
    @IBOutlet weak var viewCalfMain: UIView!
    
    @IBOutlet weak var viewCalfColor: UIView!
    
    @IBOutlet weak var lblFColor: UILabel!
    @IBOutlet weak var lblSColor: UILabel!
    @IBOutlet weak var lblTColor: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var heightTV: NSLayoutConstraint!
   
    var delegateReload: reloadCell?
    
    var arrAllRpe: [[String: Any]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblView.register(UINib(nibName: "HunterDataTVCell", bundle: nil), forCellReuseIdentifier: "HunterDataTVCell")
        tblView.dataSource = self
        tblView.delegate = self
        
        // Initialization code
    }

    deinit {
        tblView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", object as? UITableView == tblView {
            heightTV.constant = tblView.contentSize.height
            layoutIfNeeded()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - TV Delegate & Datasource
extension HunterReportingTblViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllRpe.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HunterDataTVCell") as! HunterDataTVCell
        
        if indexPath.item == 0 {
            cell.lblTitle.text = ""

            cell.lblFValue.text = "2021"
            cell.lblSValue.text = "2022"
            cell.lblTValue.text = "2023"
            cell.lblFourValue.text = "2024"
                
        } else {
            let dicData = arrAllRpe[indexPath.item-1]
            
            let metric_name = dicData["metric_name"] as? String ?? ""
            cell.lblTitle.text = metric_name
            
            
            if let value = dicData["value"] as? [[String: Any]] {
                for val in value {
                    let year = val["year"] as? String ?? ""
                    let percent = val["metric_in_percent"] as? String ?? ""
                    print("   Year:", year, "Value:", percent)
                    
                    if year == "2021" {
                        cell.lblFValue.text = percent
                    }
                    
                    if year == "2022" {
                        cell.lblSValue.text = percent
                    }
                    
                    if year == "2023" {
                        cell.lblTValue.text = percent
                    }
                    
                    if year == "2024" {
                        cell.lblFourValue.text = percent
                    }
                }
            }
            
        }
        
        if indexPath.item == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.viewLineB.isHidden = true
        } else {
            cell.viewLineB.isHidden = false
        }
        
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)

        if indexPath.row == 0 {
            // First row
            DispatchQueue.main.async {
                cell.viewFirstData.addGradient(withColors: [
                    UIColor.white.cgColor,
                    UIColor(hexString: "#FDE4D6").cgColor
                ])
                cell.viewThirdData.addGradient(withColors: [
                    UIColor.white.cgColor,
                    UIColor(hexString: "#FDE4D6").cgColor
                ])
            }
            
        } else if indexPath.row == numberOfRows - 1 {
            
            DispatchQueue.main.async {
                cell.viewFirstData.addGradient(withColors: [
                    UIColor(hexString: "#FDE4D6").cgColor,
                    UIColor.white.cgColor
                ])
                cell.viewThirdData.addGradient(withColors: [
                    UIColor(hexString: "#FDE4D6").cgColor,
                    UIColor.white.cgColor
                ])
            }
            
        } else {
            // Middle rows
            cell.viewFirstData.backgroundColor = UIColor(hexString: "#FDE4D6")
            cell.viewThirdData.backgroundColor = UIColor(hexString: "#FDE4D6")
            
            // Optional: clear gradients for other rows if not needed
            cell.viewFirstData.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
            cell.viewThirdData.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 27 : UITableView.automaticDimension
    }
    
    
}
