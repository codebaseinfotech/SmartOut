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
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    var arrSeasonId = NSMutableArray()
    
    var isDropDownVisible = false
    var selectDropName = "1"
    
    
    var expandedIndexSet: Set<Int> = []
    
    var arrAllDataList = AppDelegate.appDelegate.dicAllData
    var arrAllWmuData: [HuntingSeason] = []
    var arrAnimal: [Animal] = []
    
    
    var arrHuntingSeasons: [HuntingSeason] = []
    
    var arrHuntingSeasonWmus: [HuntingSeasonWMU] = []
    
    var filteredWMUs: [WMU] = []
    
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
        
//        listCollectionView.delegate = self
//        listCollectionView.dataSource = self
        
        viewDropDownList.isHidden = true
        arrAnimal = arrAllDataList.animals
        
        // ✅ Build filtered WMU list
        let seasonWMUIds = Set(arrAllDataList.hunting_season_wmus.map { $0.wmu_id ?? 0 })
        filteredWMUs = arrAllDataList.wmu.filter { wmu in
            if let id = wmu.id {
                return seasonWMUIds.contains(id)
            }
            return false
        }
        
        // ✅ Insert "All WMUs" at first position if exists
        if let first = arrAllDataList.wmu.first(where: { $0.name == "1" }) {
            filteredWMUs.insert(first, at: 0)
        }
        
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
        
        loadAllSeasons()
        
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
    
    // MARK: - Season Loading
    
    private func loadAllSeasons() {
        arrHuntingSeasons.removeAll()
        arrSeasonId.removeAllObjects()
        
        // Collect all valid season IDs
        for obj in arrAllDataList.hunting_season_wmus {
            let seasonId = obj.season_id ?? 0
            if !arrSeasonId.contains(seasonId) {
                arrSeasonId.add(seasonId)
            }
        }
        
        // Add matching hunting seasons
        for objSeason in arrAllDataList.hunting_seasons {
            if arrSeasonId.contains(objSeason.id ?? 0) {
                let seasonId = objSeason.id ?? 0
                if !arrHuntingSeasons.contains(where: { $0.id == seasonId }) {
                    arrHuntingSeasons.append(objSeason)
                }
            }
        }
        
        // Filter animals that actually have seasons
        arrAnimal = arrAllDataList.animals.filter { animal in
            arrHuntingSeasons.contains { $0.animal_id == animal.id }
        }
    }
    
    private func loadSeasons(forWMU wmuId: Int) {
        arrHuntingSeasons.removeAll()
        arrSeasonId.removeAllObjects()
        
        // Collect season IDs for this WMU
        for objwmu in arrAllDataList.hunting_season_wmus {
            if wmuId == objwmu.wmu_id {
                let seasonId = objwmu.season_id ?? 0
                if !arrSeasonId.contains(seasonId) {
                    arrSeasonId.add(seasonId)
                }
            }
        }
        
        // Add matching hunting seasons
        for objSeason in arrAllDataList.hunting_seasons {
            if arrSeasonId.contains(objSeason.id ?? 0) {
                let seasonId = objSeason.id ?? 0
                if !arrHuntingSeasons.contains(where: { $0.id == seasonId }) {
                    arrHuntingSeasons.append(objSeason)
                }
            }
        }
        
        // Filter animals that actually have seasons
        arrAnimal = arrAllDataList.animals.filter { animal in
            arrHuntingSeasons.contains { $0.animal_id == animal.id }
        }
    }
    
    
    
}

extension OntarioHuntingSeasonsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblViewList {
            return arrAnimal.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewDropDown {
            return filteredWMUs.count
        } else if tableView == tblViewList {
            if expandedSections.contains(section) {
                let animalId = arrAnimal[section].id ?? 0
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
            
            let wmu = filteredWMUs[indexPath.row]
            if wmu.name == "1" {
                cell.lblDropDownName.text = "All WMUs"
            } else {
                cell.lblDropDownName.text = "WMU " + (wmu.name ?? "")
            }
            
            return cell
            
        } else if tableView == tblViewList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListDetailsTblViewCell", for: indexPath) as! ListDetailsTblViewCell
            let animalId = arrAnimal[indexPath.section].id ?? 0
            let filteredSeasons = arrHuntingSeasons.filter { $0.animal_id == animalId }
            let dicData = filteredSeasons[indexPath.row]
            
            cell.configure(with: dicData)
            cell.lblwmu.text = dicData.short_wmu_list ?? ""
            
            cell.viewRifle.isHidden = dicData.rifles_allowed != 1
            cell.viewShortgun.isHidden = dicData.shotguns_allowed != 1
            cell.viewMuzzleLoader.isHidden = dicData.muzzleloaders_allowed != 1
            cell.viewBow.isHidden = dicData.bows_allowed != 1
            
            let season_resident = (dicData.season_resident ?? "") + " " + "(Resident)"
            let season_non_resident = (dicData.season_non_resident ?? "") + " " + "(Non-resident)"
            let season = season_resident != "" ? season_resident + "\n" + season_non_resident : season_non_resident
            cell.lblSeason.text = season
            
            cell.lblConditionS.text = dicData.conditions_text
            cell.viewCondtionMain.isHidden = (dicData.conditions_text ?? "").isEmpty
            cell.viewMainSeason.isHidden = (dicData.season_resident ?? "").isEmpty && (dicData.season_non_resident ?? "").isEmpty
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblViewDropDown {
            let selectedWMU = filteredWMUs[indexPath.row]
            if selectedWMU.id == 1 {
                lblDropdownTitle.text = "All WMUs"
                selectedwmuID = ""
                loadAllSeasons()
            } else {
                lblDropdownTitle.text = "WMU " + (selectedWMU.name ?? "")
                selectedwmuID = selectedWMU.name ?? ""
                loadSeasons(forWMU: selectedWMU.id ?? 0)
            }
            
            tblViewList.reloadData()
            isDropDownVisible = false
            UIView.animate(withDuration: 0.2) {
                self.viewDropDownList.isHidden = true
                self.imgDropdown.transform = .identity
            }
            
        } else if tableView == tblViewList {
            if expandedIndexDocument == indexPath {
                expandedIndexDocument = nil
            } else {
                expandedIndexDocument = indexPath
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblViewDropDown {
            return 60
        } else if tableView == tblViewList {
            return UITableView.automaticDimension
        }
        return UITableView.automaticDimension
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
            headerView.tag = section
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:)))
            headerView.addGestureRecognizer(tapGesture)
            
            let headerData = arrAnimal[section]
            headerView.lblName.text = headerData.name ?? "Exception Type"
            headerView.imgPic.image = UIImage(named: headerData.image_path ?? "")
            
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

//extension OntarioHuntingSeasonsVC: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//    
//    
//}
