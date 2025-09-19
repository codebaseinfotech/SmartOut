//
//  HunterReportingData.swift
//  SmartOut
//
//  Created by iMac on 15/09/25.
//

import UIKit
import LGSideMenuController
import DGCharts

class HunterReportingData: UIViewController {

    @IBOutlet weak var tblViewHunterReportingData: UITableView!

    var arrAllData = AppDelegate.appDelegate.arrAllData
    var didReloadOnce = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewHunterReportingData.register(UINib(nibName: "HunterReportingTblViewCell", bundle: nil), forCellReuseIdentifier: "HunterReportingTblViewCell")
        tblViewHunterReportingData.dataSource = self
        tblViewHunterReportingData.delegate = self

        print("Animal Data \(arrAllData.count)")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        // Highlight Home in side menu
        if let sideMenu = self.sideMenuController?.leftViewController as? SideMenuVC {
            sideMenu.updateSelectedMenu(index: 1)
        }
    }

    @IBAction func clickedSidemenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true, completion: nil)
    }
    

}

extension HunterReportingData: UITableViewDelegate, UITableViewDataSource, reloadCell {

    func reloadData() {
        if !didReloadOnce {
            tblViewHunterReportingData.reloadData()
            didReloadOnce = true
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewHunterReportingData.dequeueReusableCell(withIdentifier: "HunterReportingTblViewCell") as! HunterReportingTblViewCell
        
        let dicData = arrAllData[indexPath.row]
         
        let animal_name = dicData["animal_name"] as? String ?? ""
        
        cell.delegateReload = self
        
        cell.lblTitle.text = animal_name
        cell.imgAnimal.image = UIImage(named: dicData["animal_image"] as? String ?? "")

        if let staticSubData = dicData["static_sub_data"] as? [[String: Any]], !staticSubData.isEmpty {
            for sub in staticSubData {
                let label = sub["metric_name"] as? String ?? ""
                let valueString = sub["value"] as? String ?? "0"
                
                if label.lowercased() == "bull" || label.lowercased() == "buck" {
                    cell.lblBullValue.text = valueString
                }
                if label.lowercased() == "cow" || label.lowercased() == "doe" {
                    cell.lblCowValue.text = valueString
                }
                if label.lowercased() == "calf" || label.lowercased() == "fawn" {
                    cell.lblCalfValue.text = valueString
                }
                
                if animal_name == "White-tailed Deer" {
                    cell.lblBull.text = "Buck"
                    cell.lblFColor.text = "Buck"
                    
                    cell.lblCow.text = "Doe"
                    cell.lblSColor.text = "Doe"
                    
                    cell.lblCalf.text = "Fawn"
                    cell.lblTColor.text = "Fawn"
                    
                }
                
                if animal_name == "Moose" {
                    cell.lblBull.text = "Buck"
                    cell.lblFColor.text = "Buck"
                    
                    cell.lblCow.text = "Doe"
                    cell.lblSColor.text = "Doe"
                    
                    cell.lblCalf.text = "Calf"
                    cell.lblTColor.text = "Calf"
                    
                }
                
                if animal_name == "Elk" {
                    cell.lblBull.text = "Bull"
                    cell.lblFColor.text = "Bull"
                    
                    cell.lblCow.text = "Cow"
                    cell.lblSColor.text = "Cow"
                    
                    cell.viewClaf.isHidden = true
                    cell.viewCalfMain.isHidden = true
                    cell.viewCalfColor.isHidden = true
                }
            }
            cell.collectionViewDataTable.reloadData()
        }
        
        if let chatr_data = dicData["chatr_data"] as? [[String: Any]], !chatr_data.isEmpty {
            
            cell.viewMainChart.isHidden = false
            cell.viewMainCharS.isHidden = true
            
            var directEntries: [PieChartDataEntry] = []
            
            for (i, chart) in chatr_data.enumerated() {
                let title = chart["title"] as? String ?? ""
                
                // Case 1: value array (e.g. Black Bear, Turkey)
                if let values = chart["value"] as? [[String: Any]] {
                    var entries: [PieChartDataEntry] = []
                    for v in values {
                        let label = v["label"] as? String ?? ""
                        let percent = v["value_in_percent"] as? Double ?? 0.0
                        entries.append(PieChartDataEntry(value: percent, label: label))
                    }
                    
                    if i == 0 {
                        cell.lblFChartName.text = title
                        PieChart.shared.setupChart(
                            view: cell.viewSpringChart,
                            entries: entries,
                            colors: [UIColor.primary, UIColor.systemBlue]
                        )
                    } else if i == 1 {
                        cell.lblSChartName.text = title
                        PieChart.shared.setupChart(
                            view: cell.viewFallChart,
                            entries: entries,
                            colors: [UIColor.primary, UIColor.systemBlue]
                        )
                    }
                }
                
                // Case 2: direct value_in_percent (e.g. Moose, Deer, Elk)
                else if let percent = chart["value_in_percent"] as? Double {
                    directEntries.append(PieChartDataEntry(value: percent, label: title))
                }
            }
            
            if !directEntries.isEmpty {
                cell.viewMainCharS.isHidden = false
                cell.viewMainChart.isHidden = true
                PieChart.shared.setupChart(
                    view: cell.view3ValueChart,
                    entries: directEntries,
                    colors: [UIColor.primary, UIColor.systemBlue, UIColor.systemYellow]
                )
            }
            cell.collectionViewDataTable.reloadData()
        } else {
            // Case 3: no chart data (Wolf & Coyote)
            cell.viewMainChart.isHidden = true
            cell.viewMainCharS.isHidden = true
        }
        
        if let static_data = dicData["static_data"] as? [[String: Any]] {
            cell.arrAllRpe = static_data
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        return 200
    }
}
