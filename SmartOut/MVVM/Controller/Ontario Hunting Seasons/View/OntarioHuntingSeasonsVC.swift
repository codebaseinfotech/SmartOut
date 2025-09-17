//
//  OntarioHuntingSeasonsVC.swift
//  SmartOut
//
//  Created by iMac on 15/09/25.
//

import UIKit
import LGSideMenuController

class OntarioHuntingSeasonsVC: UIViewController {

    @IBOutlet weak var tblViewDropDown: UITableView!
    
    @IBOutlet weak var lblDropdownTitle: UILabel!
    @IBOutlet weak var imgDropdown: UIImageView!
    
    @IBOutlet weak var viewDropDownList: UIView!
    
    @IBOutlet weak var tblViewList: UITableView!
    
    
    var arrDropDownList = ["All WMUs", "WMU 1A", "WMU 1B", "WMU 1C", "WMU 1D", "WMU 2", "WMU 3", "WMU 4", "WMU 5", "WMU 6"]
    
    var isDropDownVisible = false
    
    var expandedIndexSet: Set<Int> = []
    
    var arrAllDataList = AppDelegate.appDelegate.dicAllData
    var arrAllWmuData: [HuntingSeason] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewDropDown.register(UINib(nibName: "DropDownTblViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTblViewCell")
        tblViewDropDown.dataSource = self
        tblViewDropDown.delegate = self
        
        tblViewList.register(UINib(nibName: "ListTblVIewCell", bundle: nil), forCellReuseIdentifier: "ListTblVIewCell")
        tblViewList.dataSource = self
        tblViewList.delegate = self
        
        viewDropDownList.isHidden = true
        
//        lblDropdownTitle.text = arrDropDownList.first
        
        let name = arrAllDataList.wmu.first?.name == "1" ? "All WMUs" : "WMU" + " " + (arrAllDataList.wmu.first?.name ?? "")
        
        lblDropdownTitle.text = name
        
        let seasonIdToCheck = arrAllDataList.wmu.first?.id ?? 0
        
        let fishingSeasonsData = arrAllDataList.hunting_seasons.filter { $0.animalId == seasonIdToCheck }
        print("Fishing Seasons:", fishingSeasonsData.count)
        arrAllWmuData = fishingSeasonsData
        tblViewDropDown.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func clickedSideMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true, completion: nil)
    }
    
    @IBAction func clickedOpenDropDown(_ sender: Any) {
        isDropDownVisible.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.viewDropDownList.isHidden = !self.isDropDownVisible
            
            self.imgDropdown.transform = self.isDropDownVisible ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }
    
    @objc func didTapTopView(_ sender: UITapGestureRecognizer) {
        guard let row = sender.view?.tag else { return }
        
        if expandedIndexSet.contains(row) {
            expandedIndexSet.remove(row)
        } else {
            expandedIndexSet.insert(row)
        }
        
        tblViewList.beginUpdates()
        tblViewList.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        tblViewList.endUpdates()
    }
    
    
    
}

extension OntarioHuntingSeasonsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewDropDown {
            return arrAllDataList.wmu.count
        } else if tableView == tblViewList {
            return 20
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblViewDropDown {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTblViewCell", for: indexPath) as! DropDownTblViewCell
//            cell.lblDropDownName.text = arrDropDownList[indexPath.row]
            
            let name = arrAllDataList.wmu.first?.name == "1" ? "All WMUs" : "WMU" + " " + (arrAllDataList.wmu.first?.name ?? "")
            
            cell.lblDropDownName.text = name
            
            return cell
        } else if tableView == tblViewList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTblVIewCell", for: indexPath) as! ListTblVIewCell
            
            cell.lblTitle.text = "Item \(indexPath.row + 1)"
            
            cell.isExpanded = expandedIndexSet.contains(indexPath.row)
            
            cell.viewTop.tag = indexPath.row
            cell.viewTop.gestureRecognizers?.forEach { cell.viewTop.removeGestureRecognizer($0) } // clear old gestures
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTopView(_:)))
            cell.viewTop.addGestureRecognizer(tap)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblViewDropDown {
            return 60
        } else if tableView == tblViewList {
            return UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblViewDropDown {
            lblDropdownTitle.text = arrDropDownList[indexPath.row]
            
            isDropDownVisible = false
            UIView.animate(withDuration: 0.3) {
                self.viewDropDownList.isHidden = true
                self.imgDropdown.transform = .identity
            }
        } else if tableView == tblViewList {
            print("Selected main list row: \(indexPath.row)")
        }
    }
}
