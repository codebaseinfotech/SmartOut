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
    
    var expandedSections: Set<Int> = []
    
    var selectedwmuID = "1"
    var expandedIndexDocument: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblViewDropDown.sectionHeaderTopPadding = 0
        tblViewDropDown.register(UINib(nibName: "DropDownTblViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTblViewCell")
        tblViewDropDown.dataSource = self
        tblViewDropDown.delegate = self
        
        tblViewList.sectionFooterHeight = 0
        tblViewList.sectionHeaderTopPadding = 8
        tblViewList.register(UINib(nibName: "ListDetailsTblViewCell", bundle: nil), forCellReuseIdentifier: "ListDetailsTblViewCell")
        tblViewList.dataSource = self
        tblViewList.delegate = self
        
        viewDropDownList.isHidden = true
        
        arrAnimal = arrAllDataList.animals
        
        // Default = show "All WMUs"
        lblDropdownTitle.text = "All WMUs"
        selectedwmuID = "" // empty means include all
        
        arrHuntingSeasons.removeAll()
        arrSeasonId.removeAllObjects()
        
        // Collect all season IDs
        for obj in arrAllDataList.hunting_season_wmus {
            let seasonId = obj.season_id ?? 0
            if !arrSeasonId.contains(seasonId) {
                arrSeasonId.add(seasonId)
            }
        }
        
        // Add all hunting seasons
        for objSeason in arrAllDataList.hunting_seasons {
            if arrSeasonId.contains(objSeason.id ?? 0) {
                let seasonId = objSeason.id ?? 0
                let animalId = objSeason.animal_id ?? 0
                
                let alreadyExists = arrHuntingSeasons.contains {
                    $0.id == seasonId || $0.animal_id == animalId
                }
                if !alreadyExists {
                    arrHuntingSeasons.append(objSeason)
                }
            }
        }
        
        tblViewList.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblViewList {
            return arrHuntingSeasons.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewDropDown {
            return arrAllDataList.wmu.count
        } else if tableView == tblViewList {
            if expandedSections.contains(section) {
                let animalId = arrAllDataList.animals[section].id ?? 0
                return arrHuntingSeasons.filter { $0.animal_id == animalId }.count
            } else {
                return 0
            }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListDetailsTblViewCell", for: indexPath) as! ListDetailsTblViewCell
            
            let animalId = arrAllDataList.animals[indexPath.section].id ?? 0
            let filteredSeasons = arrHuntingSeasons.filter { $0.animal_id == animalId }
            let dicData = filteredSeasons[indexPath.row]
            
            cell.configure(with: dicData)
            
            cell.lblwmu.text = dicData.short_wmu_list ?? ""
            
            cell.viewRifle.isHidden = dicData.rifles_allowed == 1 ? false : true
            cell.viewShortgun.isHidden = dicData.shotguns_allowed == 1 ? false : true
            cell.viewMuzzleLoader.isHidden = dicData.muzzleloaders_allowed == 1 ? false : true
            cell.viewBow.isHidden = dicData.bows_allowed == 1 ? false : true
            
            let season_resident = (dicData.season_resident ?? "") + " " + "(Resident)"
            let season_non_resident = (dicData.season_resident ?? "") + " " + "(Non-resident)"
            
            let season = season_resident != "" ? season_resident + "\n" + season_non_resident : season_non_resident
            
            cell.lblSeason.text = season
            cell.lblConditionS.text = dicData.conditions_text
            
            cell.viewCondtionMain.isHidden = dicData.conditions_text != "" ? false : true
            
            cell.viewMainSeason.isHidden = dicData.season_resident != "" && dicData.season_non_resident != "" ? false : true
            
            // Reset before filling
            //            cell.arrHuntingSeasons = []
            //
            //            // Find animal info
            //            if let objAnimal = arrAllDataList.animals.first(where: { $0.id == animalID }) {
            //                cell.lblTitle.text = objAnimal.name ?? ""
            //
            //                if let imagePath = objAnimal.image_path {
            //                    let imageName = imagePath.replacingOccurrences(of: ".png", with: "")
            //                    cell.imgMain.image = UIImage(named: imageName)
            //                } else {
            //                    cell.imgMain.image = nil
            //                }
            //            }
            //
            //            // Filter hunting seasons for this animal + selected WMU
            //            for objSet in arrHuntingSeasons {
            //                if animalID == objSet.animal_id {
            ////                    let expandedWMUs = expandWMUList(objSet.short_wmu_list ?? "")
            ////                    if expandedWMUs.contains(selectedwmuID) {
            //                    if objSet.short_wmu_list != "" {
            //                        cell.arrHuntingSeasons.append(objSet)
            //                    }
            ////                    }
            //                }
            //            }
            //
            //
            //            // Reload nested table
            //            cell.tblViewListDetails.reloadData()
            //
            //            let isExpanded = expandedIndexDocument == indexPath
            //
            //            cell.viewBottomDetails.isHidden = !isExpanded
            ////            // Rotate the arrow
            //            UIView.animate(withDuration: 0) {
            //                cell.imgDropDown.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            //            }
            //
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
            let selectedWMU = arrAllDataList.wmu[indexPath.item]
            if selectedWMU.name == "1" {
                lblDropdownTitle.text = "All WMUs"
                selectedwmuID = "" // show all
                arrHuntingSeasons.removeAll()
                arrSeasonId.removeAllObjects()
                for obj in arrAllDataList.hunting_season_wmus {
                    let seasonId = obj.season_id ?? 0
                    if !arrSeasonId.contains(seasonId) {
                        arrSeasonId.add(seasonId)
                    }
                }
                for objSeason in arrAllDataList.hunting_seasons {
                    if arrSeasonId.contains(objSeason.id ?? 0) {
                        let seasonId = objSeason.id ?? 0
                        let animalId = objSeason.animal_id ?? 0
                        let alreadyExists = arrHuntingSeasons.contains {
                            $0.id == seasonId || $0.animal_id == animalId
                        }
                        if !alreadyExists {
                            arrHuntingSeasons.append(objSeason)
                        }
                    }
                }
            } else {
                lblDropdownTitle.text = "WMU " + (selectedWMU.name ?? "")
                let wmuName = selectedWMU.name
                let numericOnly = wmuName?.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                selectedwmuID = numericOnly ?? ""
                arrHuntingSeasons.removeAll()
                arrSeasonId.removeAllObjects()
                let id = selectedWMU.id ?? 0
                for objwmu in arrAllDataList.hunting_season_wmus {
                    if id == objwmu.wmu_id {
                        let seasonId = objwmu.season_id ?? 0
                        if !arrSeasonId.contains(seasonId) {
                            arrSeasonId.add(seasonId)
                        }
                    }
                }
                for objSeason in arrAllDataList.hunting_seasons {
                    if arrSeasonId.contains(objSeason.id ?? 0) {
                        let seasonId = objSeason.id ?? 0
                        let animalId = objSeason.animal_id ?? 0
                        let alreadyExists = arrHuntingSeasons.contains {
                            $0.id == seasonId || $0.animal_id == animalId
                        }
                        if !alreadyExists {
                            arrHuntingSeasons.append(objSeason)
                        }
                    }
                }
            }
            tblViewList.reloadData()
            isDropDownVisible = false
            UIView.animate(withDuration: 0.0) {
                self.viewDropDownList.isHidden = true
                self.imgDropdown.transform = .identity
            }
        } else if tableView == tblViewList {
            print("Selected main list row: \(indexPath.row)")
            
            if expandedIndexDocument == indexPath {
                expandedIndexDocument = nil
            } else {
                // Otherwise, expand the new cell and collapse any previously expanded cell
                expandedIndexDocument = indexPath
            }
            // Reload the table view to update the views
            tableView.reloadRows(at: [indexPath], with: .none)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblViewList {
            return UITableView.automaticDimension
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblViewList {
            let headerView = Bundle.main.loadNibNamed("FishindHeaderView", owner: self, options: nil)?.first as! FishindHeaderView
            headerView.backgroundColor = .green
            
            headerView.tag = section
            
            // Add tap gesture
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:)))
            headerView.addGestureRecognizer(tapGesture)
            
            //            // Configure header title
            let headerData = arrAllDataList.animals[section]
            headerView.lblName.text = headerData.name ?? "Exception Type"
            
            headerView.imgPic.image = UIImage(named: headerData.image_path ?? "")
            
            
            // Arrow rotation based on expansion
            if expandedSections.contains(section) {
                headerView.imgDrop.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
                headerView.imgDrop.transform = .identity
            }
            
            return headerView
        }
        return UIView()
    }
    
    @objc func handleHeaderTap(_ gesture: UITapGestureRecognizer) {
        guard let headerView = gesture.view else { return }
        let section = headerView.tag
        
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        
        tblViewList.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
