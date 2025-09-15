//
//  HunterReportingData.swift
//  SmartOut
//
//  Created by iMac on 15/09/25.
//

import UIKit
import LGSideMenuController

class HunterReportingData: UIViewController {

    @IBOutlet weak var tblViewHunterReportingData: UITableView!
    
    var arrList = ["Black Bear", "Moose", "White-tailed Deer", "Wild Turkey", "Wolf and Coyote", "Elk"]
    var arrImg = ["bear_orange", "moose-orange", "deer_Orange", "turkey_orange", "wolf_orange", "elk_orange"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewHunterReportingData.register(UINib(nibName: "HunterReportingTblViewCell", bundle: nil), forCellReuseIdentifier: "HunterReportingTblViewCell")
        tblViewHunterReportingData.dataSource = self
        tblViewHunterReportingData.delegate = self
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
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewHunterReportingData.dequeueReusableCell(withIdentifier: "HunterReportingTblViewCell") as! HunterReportingTblViewCell
        
        cell.lblTitle.text = arrList[indexPath.row]
        cell.imgAnimal.tintColor = .primary
        cell.imgAnimal.image = UIImage(named: arrImg[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        return 200
    }
}
