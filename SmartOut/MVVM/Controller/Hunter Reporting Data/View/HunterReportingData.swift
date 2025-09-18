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
    
    var arrList = ["Black Bear", "Moose", "White-tailed Deer", "Wild Turkey", "Wolf and Coyote", "Elk"]
    var arrImg = ["bear_orange", "moose-orange", "deer_Orange", "turkey_orange", "wolf_orange", "elk_orange"]
    
    var arrAllDataList = AppDelegate.appDelegate.dicAllData
    var arrAnimalData: [Animal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewHunterReportingData.register(UINib(nibName: "HunterReportingTblViewCell", bundle: nil), forCellReuseIdentifier: "HunterReportingTblViewCell")
        tblViewHunterReportingData.dataSource = self
        tblViewHunterReportingData.delegate = self
        
        
        var seen = Set<Int>()
        let uniqueOrdered = arrAllDataList.hunter_report_statistic.filter { seen.insert($0.animal_id ?? 0).inserted }
        let animalIds = uniqueOrdered.map { $0.animal_id }

        let selectedAnimals = arrAllDataList.animals.filter { animalIds.contains($0.id) }
        arrAnimalData = selectedAnimals
        tblViewHunterReportingData.reloadData()

        print("Animal Data \(selectedAnimals.count)")
        
        
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

extension HunterReportingData: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAnimalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewHunterReportingData.dequeueReusableCell(withIdentifier: "HunterReportingTblViewCell") as! HunterReportingTblViewCell
        
        let dicData = arrAnimalData[indexPath.row]
        cell.lblTitle.text = dicData.name
        cell.imgAnimal.tintColor = .primary
        cell.imgAnimal.image = UIImage(named: dicData.image_path ?? "")
        
        let animalHarvests = arrAllDataList.hunter_report_harvest.filter { $0.animal_id == dicData.id }

        // group by title
        let groupedByTitle = Dictionary(grouping: animalHarvests, by: { $0.title ?? "" })

        let uniqueTitles = Array(groupedByTitle.keys).filter { !$0.isEmpty }

        if uniqueTitles.count > 1 {
            // First chart
            if let springItems = groupedByTitle[uniqueTitles[0]] {
                cell.lblFChartName.text = uniqueTitles[0]
                let entries = springItems.map {
                    PieChartDataEntry(value: Double($0.value_in_percent ?? 0),
                                      label: $0.label ?? "")
                }
                PieChart.shared.setupChart(view: cell.viewSpringChart,
                                           entries: entries,
                                           colors: [.systemBlue, .orange, .yellow])
            }

            // Second chart
            if let fallItems = groupedByTitle[uniqueTitles[1]] {
                cell.lblSChartName.text = uniqueTitles[1]
                let entries = fallItems.map {
                    PieChartDataEntry(value: Double($0.value_in_percent ?? 0),
                                      label: $0.label ?? "")
                }
                PieChart.shared.setupChart(view: cell.viewFallChart,
                                           entries: entries,
                                           colors: [.systemBlue, .orange, .yellow])
            }
        } else {
            cell.lblFChartName.isHidden = true
            cell.lblSChartName.isHidden = true
        }
        
        let filteredStats = arrAllDataList.hunter_report_statistic.filter { $0.animal_id == dicData.id }

        // Step 2: group by metric_name

        // Step 2: Extract unique metric names
        let uniqueMetricNames = Array(Set(arrAllDataList.hunter_report_statistic.compactMap { $0.metric_name }))
 
        var arrListNamesd: [HunterReportStatistic] = []
        
        var hunter_report_statistic: [HunterReportStatistic] = []
        
        for obj in arrAllDataList.hunter_report_statistic {
            if obj.animal_id == 2 {
                hunter_report_statistic.append(obj)
            }
        }
        
        print("dfdfd\(arrListNamesd.count)")
        let dsfdsf = arrAllDataList.hunter_report_statistic.filter {
            $0.metric_name.map(uniqueMetricNames.contains) ?? false
        }

        
        let groupedDict = Dictionary(grouping: dsfdsf) { $0.metric_name ?? "" }

        print("Add String: \(uniqueMetricNames)")

        // ✅ Step 3: convert to array of MetricGroup
        let metricGroups: [MetricGroup] = groupedDict.map { (key, stats) in
            let data = stats.compactMap { stat -> (String, Double)? in
                if let year = stat.year {
                    if let number = stat.metric_in_number {
                        return (year, number) as? (String, Double)
                    } else if let percent = stat.metric_in_percent {
                        return (year, percent)
                    }
                }
                return nil
            }
            // Sort years ascending (optional)
            let sortedData = data.sorted { $0.0 < $1.0 }
            return MetricGroup(title: key, data: sortedData)
        }
        
        cell.arrListName = metricGroups
        cell.collectionViewDataTable.reloadData()
        
        let entries3 = [PieChartDataEntry(value: 27.0, label: "BUll"),
                        PieChartDataEntry(value: 14.3, label: "Cow"),
                        PieChartDataEntry(value: 58.7, label: "Calf")]
        PieChart.shared.setupChart(view: cell.view3ValueChart, entries: entries3, colors: [.systemBlue, .orange, .yellow])

        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        return 200
    }
}
