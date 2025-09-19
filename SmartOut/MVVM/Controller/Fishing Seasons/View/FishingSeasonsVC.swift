//
//  FishingSeasonsVC.swift
//  SmartOut
//
//  Created by iMac on 16/09/25.
//

import UIKit
import LGSideMenuController

class FishingSeasonsVC: UIViewController {

    @IBOutlet weak var lblListName: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    
    @IBOutlet weak var viewMainList: UIView!
    
    @IBOutlet weak var tblVIewList: UITableView!
    
    @IBOutlet weak var lblZoneWideSeason: UILabel!
    @IBOutlet weak var lblAdditionalOppo: UILabel!
    @IBOutlet weak var lblExceptions: UILabel!
    
    @IBOutlet weak var viewZoneWideBottomLine: UIView!
    @IBOutlet weak var viewAdditionalBottomLine: UIView!
    @IBOutlet weak var viewExceptionsBottomLine: UIView!
    
    @IBOutlet weak var tblViewZoneWide: UITableView!
    
    @IBOutlet weak var viewZoneWideMain: UIView!
    @IBOutlet weak var viewAdditionalOppoMain: UIView!
    @IBOutlet weak var viewExceptionsMain: UIView!
    
    @IBOutlet weak var tblViewAdditionalOppo: UITableView!
    @IBOutlet weak var tblViewExceptions: UITableView!
    
    @IBOutlet weak var lblNoDataZoneWide: UILabel!
    @IBOutlet weak var lblNoDataAddOppo: UILabel!
    @IBOutlet weak var lblNoDataExceptions: UILabel!
    
    @IBOutlet weak var viewBottomPopup: UIView!
    @IBOutlet weak var popupHeightConstraint: NSLayoutConstraint!
    
    var isDropDownVisible = false
    var expandedIndexPaths: Set<IndexPath> = []
    var isPopupVisible = false
    
    var arrAllDataList = AppDelegate.appDelegate.dicAllData
    
    var arrAllFmzData: [FishingSeason] = []
    
    var exceptions: [ExceptionModel] = []
    var arrFish: [Fish] = []
    
    var fishing_exception_types: [FishingExceptionType] = []
    var exceptionsNew: [ExceptionModel] = []
    
    var expandedSections: Set<Int> = []
    var expandedIndexDocument: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblVIewList.register(UINib(nibName: "DropDownTblViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTblViewCell")
        tblVIewList.dataSource = self
        tblVIewList.delegate = self
        
        tblViewZoneWide.register(UINib(nibName: "ZoneWideTblViewCell", bundle: nil), forCellReuseIdentifier: "ZoneWideTblViewCell")
        tblViewZoneWide.dataSource = self
        tblViewZoneWide.delegate = self
        
        tblViewAdditionalOppo.register(UINib(nibName: "AdditionalOppoTblViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalOppoTblViewCell")
        tblViewAdditionalOppo.dataSource = self
        tblViewAdditionalOppo.delegate = self
        
        tblViewExceptions.sectionHeaderTopPadding = 8
        tblViewExceptions.register(UINib(nibName: "ExceptionsDetailsTblViewCell", bundle: nil), forCellReuseIdentifier: "ExceptionsDetailsTblViewCell")
        tblViewExceptions.dataSource = self
        tblViewExceptions.delegate = self
        
        viewMainList.isHidden = true
        
        lblListName.text = "FMZ" + " " + (arrAllDataList.fmz.first?.name ?? "")
        
        let seasonIdToCheck = arrAllDataList.fmz.first?.id ?? 0
        
        let fishingSeasonsData = arrAllDataList.fishing_seasons.filter { $0.fmz_id == seasonIdToCheck }
        print("Fishing Seasons:", fishingSeasonsData.count)
        arrAllFmzData = fishingSeasonsData
        
        let additional = arrAllDataList.exceptions.filter { $0.fmz_id == seasonIdToCheck && $0.fish_id != nil }
        exceptions = additional

        // 2. Get all fish_ids from additional
        let exceptionFishIds = additional.compactMap { $0.fish_id }

        // 3. Filter fish array where id is in exceptionFishIds
        let fishList = arrAllDataList.fish.filter { fish in
            exceptionFishIds.contains(fish.id ?? 0)
        }
        arrFish = fishList
        
        let additionalNew = arrAllDataList.exceptions.filter { $0.fmz_id == seasonIdToCheck }
        exceptionsNew = additionalNew

        // 1. Extract all exception_type_id values from exceptions
        let exceptionTypes = additionalNew.compactMap { $0.exception_type_id }
        
        let fisingingArr = arrAllDataList.fishing_exception_types.filter { fish in
            exceptionTypes.contains(fish.id ?? 0)
        }
        fishing_exception_types = fisingingArr

        print("Unique Exception Types:", fishing_exception_types)
        
        lblNoDataExceptions.isHidden = fishing_exception_types.count > 0 ? true : false
        lblNoDataAddOppo.isHidden = arrFish.count > 0 ? true : false
        lblNoDataAddOppo.text = "no exceptions for " + "FMZ " + (arrAllDataList.fmz.first?.name ?? "")

        tblViewZoneWide.reloadData()
        tblViewAdditionalOppo.reloadData()
        tblViewExceptions.reloadData()
        
        updateSegmentSelection(selected: .zoneWide)
        
//        viewBottomPopup.isHidden = true
        popupHeightConstraint.constant = 110
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        viewBottomPopup.addGestureRecognizer(swipeDown)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        if let sideMenu = self.sideMenuController?.leftViewController as? SideMenuVC {
            sideMenu.updateSelectedMenu(index: 3)
        }
    }
    
    @objc func handleSwipeDown() {
        hideBottomPopup()
    }
    
    // Show Popup
    func showBottomPopup() {
        viewBottomPopup.isHidden = false
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3) {
            self.popupHeightConstraint.constant = 400 // your desired height
            self.view.layoutIfNeeded()
        }
        
        isPopupVisible = true
    }
    
    // Hide Popup
    func hideBottomPopup() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popupHeightConstraint.constant = 110
            self.view.layoutIfNeeded()
        }) { _ in
            self.viewBottomPopup.isHidden = true
        }
        
        isPopupVisible = false
    }

    @IBAction func clickedSideMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true, completion: nil)
    }
    
    @IBAction func clickedOpenList(_ sender: Any) {
        isDropDownVisible.toggle()
        
        UIView.animate(withDuration: 0.0) {
            self.viewMainList.isHidden = !self.isDropDownVisible
            
            self.imgDropDown.transform = self.isDropDownVisible ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }
    
    @IBAction func clickedzoneWideSeason(_ sender: Any) {
        updateSegmentSelection(selected: .zoneWide)
    }
    
    @IBAction func clickedAdditionalOppo(_ sender: Any) {
        updateSegmentSelection(selected: .additional)
    }
    
    @IBAction func clickedExceptions(_ sender: Any) {
        updateSegmentSelection(selected: .exceptions)
    }
    
    private enum SegmentType {
        case zoneWide, additional, exceptions
    }
    
    private func updateSegmentSelection(selected: SegmentType) {
        // Reset all labels to default (gray) and hide all bottom lines
        lblZoneWideSeason.textColor = .darkGray
        lblAdditionalOppo.textColor = .darkGray
        lblExceptions.textColor = .darkGray
        
        viewZoneWideBottomLine.backgroundColor = .clear
        viewAdditionalBottomLine.backgroundColor = .clear
        viewExceptionsBottomLine.backgroundColor = .clear
        
        viewZoneWideMain.isHidden = true
        viewAdditionalOppoMain.isHidden = true
        viewExceptionsMain.isHidden = true
        // Apply active color (blue for example) and show bottom line
        switch selected {
        case .zoneWide:
            lblZoneWideSeason.textColor = .black
            viewZoneWideBottomLine.backgroundColor = .primary
            viewZoneWideMain.isHidden = false
            viewAdditionalOppoMain.isHidden = true
            viewExceptionsMain.isHidden = true
        case .additional:
            lblAdditionalOppo.textColor = .black
            viewAdditionalBottomLine.backgroundColor = .primary
            viewZoneWideMain.isHidden = true
            viewAdditionalOppoMain.isHidden = false
            viewExceptionsMain.isHidden = true
        case .exceptions:
            lblExceptions.textColor = .black
            viewExceptionsBottomLine.backgroundColor = .primary
            viewZoneWideMain.isHidden = true
            viewAdditionalOppoMain.isHidden = true
            viewExceptionsMain.isHidden = false
        }
    }
    
}

extension FishingSeasonsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblViewExceptions {
            return fishing_exception_types.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVIewList {
            return arrAllDataList.fmz.count
        } else if tableView == tblViewZoneWide {
            return arrAllFmzData.count
        } else if tableView == tblViewAdditionalOppo {
            return arrFish.count
        } else if tableView == tblViewExceptions {
            
            if !expandedSections.contains(section) { return 0 }
            
            let dicData = fishing_exception_types[section]
            let additional = exceptionsNew.filter { $0.exception_type_id == dicData.id && $0.fish_id == nil }
            return additional.count > 0 ? additional.count : arrFish.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblVIewList {
            let cell = self.tblVIewList.dequeueReusableCell(withIdentifier: "DropDownTblViewCell") as! DropDownTblViewCell
            
            cell.lblDropDownName.text = "FMZ" + " " + (arrAllDataList.fmz[indexPath.row].name ?? "")
            
            return cell
        } else if tableView == tblViewZoneWide {
            let cell = self.tblViewZoneWide.dequeueReusableCell(withIdentifier: "ZoneWideTblViewCell") as! ZoneWideTblViewCell
            
            let dicData = arrAllFmzData[indexPath.row]
            
            cell.viewMainSeason.isHidden = dicData.season != "" ? false : true
            
            cell.lblSeason.text = dicData.season ?? ""
            
            let limits = dicData.limits_non_resident != "" ? (dicData.limits_resident ?? "") + (dicData.limits_non_resident ?? "") : dicData.limits_resident
            
            cell.viewLimitsMain.isHidden = limits != "" ? false : true
            cell.lblLimit.text = limits
            
            let fish_id = dicData.fish_id ?? 0
            
            if let fish = arrAllDataList.fish.first(where: { $0.id == fish_id }) {
                print("✅ Fish with id \(fish_id) exists, name = \(fish.name ?? "No name")")
                cell.lblFish.text = fish.name
            }
            
            return cell
        } else if tableView == tblViewAdditionalOppo {
            let cell = self.tblViewAdditionalOppo.dequeueReusableCell(withIdentifier: "AdditionalOppoTblViewCell") as! AdditionalOppoTblViewCell
            
            let dicData = arrFish[indexPath.row]
            let dicDataEX = exceptions[indexPath.row]
            
            cell.lblTitle.text = dicData.name ?? ""
            
            cell.lblSeason.text = dicDataEX.season ?? ""
            cell.lblLimits.text = dicDataEX.limits ?? ""
            cell.lblDis.text = dicDataEX.description ?? ""
            
            cell.viewSeasonMain.isHidden = dicDataEX.season != "" ? false : true
            cell.viewLimitMain.isHidden = dicDataEX.limits != "" ? false : true
            cell.viewDescription.isHidden = dicDataEX.description != "" ? false : true
            
            
            let isExpanded = expandedIndexPaths.contains(indexPath)
            cell.configure(isExpanded: isExpanded)
            
            cell.toggleAction = { [weak self] in
                guard let self = self else { return }
                if isExpanded {
                    self.expandedIndexPaths.remove(indexPath)
                } else {
                    self.expandedIndexPaths.insert(indexPath)
                }
                self.tblViewAdditionalOppo.reloadRows(at: [indexPath], with: .automatic)
            }
            
            return cell
        } else if tableView == tblViewExceptions {
            let cell = self.tblViewExceptions.dequeueReusableCell(withIdentifier: "ExceptionsDetailsTblViewCell") as! ExceptionsDetailsTblViewCell
            
            let dicData = fishing_exception_types[indexPath.section]
            
            let additional = exceptionsNew.filter { $0.exception_type_id == dicData.id && $0.fish_id == nil }

            if additional.count > 0 {
                let dicData = additional[indexPath.row]
                
                cell.lblExceptionDetailsTitle.text = dicData.title ?? ""
                
                cell.viewSeason.isHidden = true
                cell.viewLimit.isHidden = true
                cell.viewDes.isHidden = false
                
                cell.lblDis.text = dicData.description ?? ""
                
                cell.viewAddi.isHidden = true
                cell.imgLoca.isHidden = !cell.viewAddi.isHidden

                cell.imgTOp.isHidden = true
            } else {
                let dicData = arrFish[indexPath.row]
                let dicDataEX = exceptions[indexPath.row]

                cell.imgTOp.isHidden = false
                cell.lblExceptionDetailsTitle.text = dicData.name ?? ""
                cell.imgTOp.tintColor = .primary
                cell.imgTOp.image = UIImage(named: dicData.image_path ?? "")
                
                cell.lblSeason.text = dicDataEX.season ?? ""
                cell.lblLimits.text = dicDataEX.limits ?? ""
                cell.lblDis.text = dicDataEX.description ?? ""
                
                cell.viewSeason.isHidden = dicDataEX.season != "" ? false : true
                cell.viewLimit.isHidden = dicDataEX.limits != "" ? false : true
                cell.viewDes.isHidden = dicDataEX.description != "" ? false : true
                
                cell.viewAddi.isHidden = false
                cell.imgLoca.isHidden = !cell.viewAddi.isHidden

            }
            
            // expanded
            let isExpanded = expandedIndexDocument == indexPath
            cell.viewBottomException.isHidden = !isExpanded
//            // Rotate the arrow
            UIView.animate(withDuration: 0) {
                cell.imgDropDown.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVIewList {
            return 60
        } else if tableView == tblViewZoneWide {
            return UITableView.automaticDimension
        } else if tableView == tblViewAdditionalOppo {
            return UITableView.automaticDimension
        } else if tableView == tblViewExceptions {
            return UITableView.automaticDimension
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblVIewList {
            lblListName.text = "FMZ" + " " + (arrAllDataList.fmz[indexPath.row].name ?? "")
            
            let seasonIdToCheck = arrAllDataList.fmz[indexPath.row].id ?? 0
            
            let fishingSeasonsData = arrAllDataList.fishing_seasons.filter { $0.fmz_id == seasonIdToCheck }
            print("Fishing Seasons:", fishingSeasonsData.count)
            arrAllFmzData = fishingSeasonsData
            
            let additional = arrAllDataList.exceptions.filter { $0.fmz_id == seasonIdToCheck && $0.fish_id != nil }
            exceptions = additional

            // 2. Get all fish_ids from additional
            let exceptionFishIds = additional.compactMap { $0.fish_id }

            // 3. Filter fish array where id is in exceptionFishIds
            let fishList = arrAllDataList.fish.filter { fish in
                exceptionFishIds.contains(fish.id ?? 0)
            }
            arrFish = fishList
            
            let additionalNew = arrAllDataList.exceptions.filter { $0.fmz_id == seasonIdToCheck }
            exceptionsNew = additionalNew
            
            let exceptionTypes = additionalNew.compactMap { $0.exception_type_id }

            let fisingingArr = arrAllDataList.fishing_exception_types.filter { fish in
                exceptionTypes.contains(fish.id ?? 0)
            }
            fishing_exception_types = fisingingArr

            print("Unique Exception Types:", fishing_exception_types)
            
            lblNoDataExceptions.isHidden = fishing_exception_types.count > 0 ? true : false

            lblNoDataAddOppo.isHidden = arrFish.count > 0 ? true : false
            lblNoDataAddOppo.text = "no exceptions for" + "FMZ" + (arrAllDataList.fmz[indexPath.row].name ?? "")
            
            DispatchQueue.main.async { [self] in
                tblViewZoneWide.reloadData()
                tblViewAdditionalOppo.reloadData()
                tblViewExceptions.reloadData()
            }
            
            isDropDownVisible = false
            UIView.animate(withDuration: 0.0) {
                self.viewMainList.isHidden = true
                self.imgDropDown.transform = .identity
            }
        } else if tableView == tblViewExceptions {
            print("Selected main list row: \(indexPath.row)")
            
            if let previous = expandedIndexDocument, previous != indexPath {
                expandedIndexDocument = indexPath
            } else if expandedIndexDocument == indexPath {
                expandedIndexDocument = nil
            }
            
            // Animate height change
            UIView.animate(withDuration: 0.3) {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            // Optional: scroll to make row fully visible
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblViewExceptions {
            return UITableView.automaticDimension
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblViewExceptions {
            let headerView = Bundle.main.loadNibNamed("FishindHeaderView", owner: self, options: nil)?.first as! FishindHeaderView
            headerView.backgroundColor = .green
            
            headerView.tag = section
            
            // Add tap gesture
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:)))
            headerView.addGestureRecognizer(tapGesture)
            
            // Configure header title
            let headerData = fishing_exception_types[section]
            headerView.lblName.text = headerData.text ?? "Exception Type"
            
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
        
        tblViewExceptions.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
