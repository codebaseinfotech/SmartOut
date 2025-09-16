//
//  HomeVC.swift
//  SmartOut
//
//  Created by iMac on 15/09/25.
//

import UIKit
import LGSideMenuController

class HomeVC: UIViewController {

    @IBOutlet weak var tblViewHomeList: UITableView!
    
    var arrImg = ["bar_chart_icon_orange", "moose-orange", "aggregate_trout_and_salmon-orange"]
    var arrList = ["Hunter Reporting Data", "Hunting Seasons 2025", "Fishing Seasons 2025"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewHomeList.register(UINib(nibName: "HomeListTblViewCell", bundle: nil), forCellReuseIdentifier: "HomeListTblViewCell")
        tblViewHomeList.dataSource = self
        tblViewHomeList.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func clickedSideMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true, completion: nil)
    }
    

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewHomeList.dequeueReusableCell(withIdentifier: "HomeListTblViewCell") as! HomeListTblViewCell
        
        cell.lblName.text = arrList[indexPath.row]
        cell.imgIcon.tintColor = .primary
        cell.imgIcon.image = UIImage(named: arrImg[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = HunterReportingData()
            self.navigationController?.pushViewController(vc, animated: false)
        } else if indexPath.row == 1 {
            let vc = OntarioHuntingSeasonsVC()
            self.navigationController?.pushViewController(vc, animated: false)
        } else if indexPath.row == 2 {
            let vc = FishingSeasonsVC()
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
}
