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
    
    
    var arrSeasonId = NSMutableArray()
    
    var isDropDownVisible = false
    var selectDropName = "1"
    
    
    var expandedIndexSet: Set<Int> = []
    
    var arrAllDataList = AppDelegate.appDelegate.dicAllData
    var arrAllWmuData: [HuntingSeason] = []
    var arrAnimal: [Animal] = []
    
    
    var arrHuntingSeasons: [HuntingSeason] = []
    
    var arrHuntingSeasonWmus: [HuntingSeasonWMU] = []
    
    var selectedwmuID = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewDropDown.register(UINib(nibName: "DropDownTblViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTblViewCell")
        tblViewDropDown.dataSource = self
        tblViewDropDown.delegate = self
        
        tblViewList.register(UINib(nibName: "ListTblVIewCell", bundle: nil), forCellReuseIdentifier: "ListTblVIewCell")
        tblViewList.dataSource = self
        tblViewList.delegate = self
        
        viewDropDownList.isHidden = true
        
        arrAnimal = arrAllDataList.animals
        
        let name = arrAllDataList.wmu.first?.name == "1" ? "All WMUs" : "WMU" + " " + (arrAllDataList.wmu.first?.name ?? "")
        
        lblDropdownTitle.text = name
        
        let seasonIdToCheck = arrAllDataList.wmu.first?.id ?? 0
        
        let fishingSeasonsData = arrAllDataList.hunting_seasons.filter { $0.animal_id == seasonIdToCheck }
        print("Fishing Seasons:", fishingSeasonsData.count)
        arrAllWmuData = fishingSeasonsData
        tblViewDropDown.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        if let sideMenu = self.sideMenuController?.leftViewController as? SideMenuVC {
            sideMenu.updateSelectedMenu(index: 2)
        }
    }

    @IBAction func clickedSideMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true, completion: nil)
    }
    
    @IBAction func clickedOpenDropDown(_ sender: Any) {
        isDropDownVisible.toggle()
        
        UIView.animate(withDuration: 0.0) {
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
            return arrHuntingSeasons.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblViewDropDown {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTblViewCell", for: indexPath) as! DropDownTblViewCell
            
            if arrAllDataList.wmu[indexPath.item].name == "1" {
                cell.lblDropDownName.text = "All WMUs"
            } else {
                cell.lblDropDownName.text = "WMU " + (arrAllDataList.wmu[indexPath.item].name ?? "")
            }
            
            return cell
            
        } else if tableView == tblViewList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTblVIewCell", for: indexPath) as! ListTblVIewCell
            
            // expanded or not
            cell.isExpanded = expandedIndexSet.contains(indexPath.row)
            
            let dicData = arrHuntingSeasons[indexPath.row]
            let animalID = dicData.animal_id ?? 0
            
            // Reset before filling
            cell.arrHuntingSeasons = []
            
            // Find animal info
            if let objAnimal = arrAllDataList.animals.first(where: { $0.id == animalID }) {
                cell.lblTitle.text = objAnimal.name ?? ""
                
                if let imagePath = objAnimal.image_path {
                    let imageName = imagePath.replacingOccurrences(of: ".png", with: "")
                    cell.imgMain.image = UIImage(named: imageName)
                } else {
                    cell.imgMain.image = nil
                }
            }
            
            // Filter hunting seasons for this animal + selected WMU
            for objSet in arrHuntingSeasons {
                if animalID == objSet.animal_id {
                    let expandedWMUs = expandWMUList(objSet.short_wmu_list ?? "")
                    if expandedWMUs.contains(selectedwmuID) {
                        cell.arrHuntingSeasons.append(objSet)
                    }
                }
            }
            
            // Reload nested table
            cell.tblViewListDetails.reloadData()
            
            // Tap gesture setup
            cell.viewTop.tag = indexPath.row
            cell.viewTop.gestureRecognizers?.forEach { cell.viewTop.removeGestureRecognizer($0) }
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTopView(_:)))
            cell.viewTop.addGestureRecognizer(tap)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func expandWMUList(_ list: String) -> [String] {
        let parts = list.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var expanded: [String] = []

        for part in parts {
            if part.contains("–") { // Handle range with en dash
                let rangeParts = part.split(separator: "–").map {
                    $0.trimmingCharacters(in: .whitespaces)
                        .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) // remove letters
                }
                if let start = Int(rangeParts.first ?? ""), let end = Int(rangeParts.last ?? "") {
                    for i in start...end {
                        expanded.append("\(i)")
                    }
                }
            } else {
                // Remove A, B, C... keep only numbers
                let numeric = part.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                if !numeric.isEmpty {
                    expanded.append(numeric)
                }
            }
        }
        return expanded
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
            
            if arrAllDataList.wmu[indexPath.item].name == "1" {
                lblDropdownTitle.text = "All WMUs"
            } else {
                lblDropdownTitle.text = "WMU" + " " + (arrAllDataList.wmu[indexPath.item].name ?? "")
            }
            let wmuName = arrAllDataList.wmu[indexPath.item].name
            let numericOnly = wmuName?.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            self.selectedwmuID = numericOnly ?? ""
            
            self.arrHuntingSeasons.removeAll()
            self.arrSeasonId.removeAllObjects()
            
            let id = arrAllDataList.wmu[indexPath.row].id ?? 0
            
            for objwmu in arrAllDataList.hunting_season_wmus {
                if id == objwmu.wmu_id {
                    let seasonId = objwmu.season_id ?? 0
                    if !arrSeasonId.contains(seasonId) { // prevents duplicates
                        arrSeasonId.add(seasonId)
                    }
                }
            }

            for objSeason in arrAllDataList.hunting_seasons {
                if arrSeasonId.contains(objSeason.id ?? 0) {
                    let seasonId = objSeason.id ?? 0
                    let animalId = objSeason.animal_id ?? 0
                    
                    // Check duplicates by both id and animal_id
                    let alreadyExists = arrHuntingSeasons.contains {
                        $0.id == seasonId || $0.animal_id == animalId
                    }
                    
                    if !alreadyExists {
                        arrHuntingSeasons.append(objSeason)
                    }
                }
            }
            
            
            
            print("arrSeasonId \(arrSeasonId)")
            
            print("arrHuntingSeasons \(arrHuntingSeasons)")

            
            self.tblViewList.reloadData()
            
            isDropDownVisible = false
            UIView.animate(withDuration: 0.0) {
                self.viewDropDownList.isHidden = true
                self.imgDropdown.transform = .identity
            }
        } else if tableView == tblViewList {
            print("Selected main list row: \(indexPath.row)")
        }
    }
}
