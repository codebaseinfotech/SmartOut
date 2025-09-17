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
        self.navigationController?.navigationBar.isHidden = true
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
        
        let animalIds = arrAllDataList.hunter_report_harvest.filter({ $0.animal_id == dicData.id})

        var seen = Set<String>()
        let uniqueTitles = animalIds.compactMap { $0.title }       // unwrap titles
                                     .filter { seen.insert($0).inserted }
        
        if uniqueTitles.count > 1 {
            cell.lblFChartName.text = uniqueTitles[0]
            cell.lblSChartName.text = uniqueTitles[1]
            
            let entries1 = [PieChartDataEntry(value: 80.0, label: "Female"),
                           PieChartDataEntry(value: 20.0, label: "Male")]
            PieChart.shared.setupChart(view: cell.viewSpringChart, entries: entries1, colors: [.systemBlue, .orange])
            
            
            let entries2 = [PieChartDataEntry(value: 37.0, label: "Female"),
                           PieChartDataEntry(value: 63.0, label: "Male")]
            PieChart.shared.setupChart(view: cell.viewFallChart, entries: entries2, colors: [.systemBlue, .orange])

            
        }
        
        
        print("selected animalIds \(animalIds)")
        
        
        
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
