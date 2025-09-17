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
    
    
    
//    var arrList = ["FMZ 1", "FMZ 2", "FMZ 3", "FMZ 4", "FMZ 5", "FMZ 6", "FMZ 7", "FMZ 8", "FMZ 9", "FMZ 10"]
    
    var isDropDownVisible = false
    var expandedIndexPaths: Set<IndexPath> = []
    var isPopupVisible = false
    
    var arrAllDataList = AppDelegate.appDelegate.dicAllData
    var arrAllFmzData: [FishingSeason] = []
    
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
        
        tblViewExceptions.register(UINib(nibName: "ExceptionsTblViewCell", bundle: nil), forCellReuseIdentifier: "ExceptionsTblViewCell")
        tblViewExceptions.dataSource = self
        tblViewExceptions.delegate = self
        
        viewMainList.isHidden = true
        
        lblListName.text = "FMZ" + " " + (arrAllDataList.fmz.first?.name ?? "")
        
        let seasonIdToCheck = arrAllDataList.fmz.first?.id ?? 0
        
        let fishingSeasonsData = arrAllDataList.fishing_seasons.filter { $0.fmz_id == seasonIdToCheck }
        print("Fishing Seasons:", fishingSeasonsData.count)
        arrAllFmzData = fishingSeasonsData
        tblViewZoneWide.reloadData()
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVIewList {
            return arrAllDataList.fmz.count
        } else if tableView == tblViewZoneWide {
            return arrAllFmzData.count
        } else if tableView == tblViewAdditionalOppo {
            return 3
        } else if tableView == tblViewExceptions {
            return 3
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
            let cell = self.tblViewExceptions.dequeueReusableCell(withIdentifier: "ExceptionsTblViewCell") as! ExceptionsTblViewCell
            
            let isExpanded = expandedIndexPaths.contains(indexPath)
            cell.isExpanded = isExpanded
            cell.viewBottomExceptionsDetails.isHidden = !isExpanded
            cell.imgDropDown.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            
            cell.toggleAction = { [weak self] in
                guard let self = self else { return }
                if isExpanded {
                    self.expandedIndexPaths.remove(indexPath)
                } else {
                    self.expandedIndexPaths.insert(indexPath)
                }
                self.tblViewExceptions.beginUpdates()
                self.tblViewExceptions.endUpdates()
                
                self.tblViewExceptions.reloadData()
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
            
            DispatchQueue.main.async { [self] in
                tblViewZoneWide.reloadData()
            }
            
            isDropDownVisible = false
            UIView.animate(withDuration: 0.0) {
                self.viewMainList.isHidden = true
                self.imgDropDown.transform = .identity
            }
        }
    }
    
}
