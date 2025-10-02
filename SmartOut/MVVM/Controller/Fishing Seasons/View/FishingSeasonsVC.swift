//
//  FishingSeasonsVC.swift
//  SmartOut
//
//  Created by Ankit Gabani on 16/09/25.
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
    
    @IBOutlet weak var collectionViewList: UICollectionView! {
        didSet {
            collectionViewList.collectionViewLayout = createCompositionalLayout()
            
            collectionViewList.delegate = self
            collectionViewList.dataSource = self
            
            collectionViewList.register(UINib(nibName: "ExceptionsDetailsCVCell", bundle: nil), forCellWithReuseIdentifier: "ExceptionsDetailsCVCell")
            
            collectionViewList.register(UINib(nibName: "ListInnerHeaderCVCell", bundle: nil), forCellWithReuseIdentifier: "ListInnerHeaderCVCell")
            
            collectionViewList.register(UINib(nibName: "HuterHeaderCVView", bundle: nil),
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: "HuterHeaderCVView")
        }
    }
    
    @IBOutlet weak var viewInnerBottomPopup: UIView!
    @IBOutlet weak var lblPopUpTitle: UILabel!
    @IBOutlet weak var txtViewPopUP: UITextView!
    
    
    var isDropDownVisible = false
    var expandedIndexPaths: Set<IndexPath> = []
    var isPopupVisible = false
    
    var arrAllDataList = AppDelegate.appDelegate.dicAllData
    
    var arrAllFmzData: [FishingSeason] = []
    
    var exceptions: [ExceptionModel] = []
    var arrFish: [Fish] = []
    
    var fishing_exception_types: [FishingExceptionType] = []
    var exceptionsNew: [ExceptionModel] = []
    var fishing_general_info: [FishingGeneralInfo] = []
    
    var expandedSections: Set<Int> = []
    var expandedSectionsAdditionalOppo: Set<Int> = []
    var expandedCells: [IndexPath: Bool] = [:]
    var expandedSeasonTypes: Set<IndexPath> = []

    var expandedIndexPath: IndexPath?
    
    var expandedExceptionTypes: Set<IndexPath> = []
    var arrAllFishing: [Fish] = []
    var fishIds: [Double] = []
    var expandedFish: Set<IndexPath> = []
    
    var fmz_id = 0
    var exceptionIds: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tblVIewList.register(UINib(nibName: "DropDownTblViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTblViewCell")
        tblVIewList.dataSource = self
        tblVIewList.delegate = self
        
        tblViewZoneWide.sectionHeaderTopPadding = 0
        tblViewZoneWide.register(UINib(nibName: "ZoneWideTblViewCell", bundle: nil), forCellReuseIdentifier: "ZoneWideTblViewCell")
        tblViewZoneWide.dataSource = self
        tblViewZoneWide.delegate = self
        
        tblViewAdditionalOppo.register(UINib(nibName: "AdditionalOppoTblViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalOppoTblViewCell")
        tblViewAdditionalOppo.dataSource = self
        tblViewAdditionalOppo.delegate = self
        
        tblViewExceptions.sectionHeaderTopPadding = 8
        tblViewAdditionalOppo.sectionHeaderTopPadding = 5
        tblViewExceptions.register(UINib(nibName: "ExceptionsDetailsTblViewCell", bundle: nil), forCellReuseIdentifier: "ExceptionsDetailsTblViewCell")
        tblViewExceptions.dataSource = self
        tblViewExceptions.delegate = self
        tblViewExceptions.estimatedRowHeight = UITableView.automaticDimension
        tblViewExceptions.rowHeight = UITableView.automaticDimension
        
        tblViewZoneWide.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
        viewMainList.isHidden = true
        
        lblListName.text = "FMZ" + " " + (arrAllDataList.fmz.first?.name ?? "")
        
        let seasonIdToCheck = arrAllDataList.fmz.first?.id ?? 0
        fmz_id = seasonIdToCheck
        let fishingSeasonsData = arrAllDataList.fishing_seasons.filter { $0.fmz_id == seasonIdToCheck }
        print("Fishing Seasons:", fishingSeasonsData.count)
        arrAllFmzData = fishingSeasonsData
        
        let additional = arrAllDataList.exceptions.filter { $0.fmz_id == seasonIdToCheck && $0.fish_id != nil && $0.is_additional_opportunity == 1 }
        exceptions = additional

        // 2. Get all fish_ids from additional
        let exceptionFishIds = additional.compactMap { $0.fish_id }

        // 3. Filter fish array where id is in exceptionFishIds
        let fishList = arrAllDataList.fish.filter { fish in
            exceptionFishIds.contains(Double(fish.id ?? Int(0.0)))
        }
        arrFish = fishList
        
        let additionalNew = arrAllDataList.exceptions.filter { $0.fmz_id == seasonIdToCheck }
        exceptionsNew = additionalNew
        
        let exceptionTypes = additionalNew.compactMap { $0.exception_type_id }
       
        let arrExten = arrAllDataList.exceptions.filter({ $0.fmz_id == fmz_id })
        
        
        for obj in arrExten {
            if !exceptionIds.contains(obj.exception_type_id ?? 0) {
                exceptionIds.append(obj.exception_type_id ?? 0)
            }
        }
        
        let filtered = arrAllDataList.fishing_exception_types.filter { exceptionIds.contains($0.id ?? 0) }
        fishing_exception_types = filtered

        print("Unique Exception Types:", fishing_exception_types)
        
        
        lblNoDataExceptions.isHidden = fishing_exception_types.count > 0 ? true : false
        lblNoDataExceptions.text = "no exceptions for FMZ " + (arrAllDataList.fmz.first?.name ?? "")
        
        lblNoDataAddOppo.isHidden = arrFish.count > 0 ? true : false
        lblNoDataAddOppo.text = "no additional opportunities for FMZ " + (arrAllDataList.fmz.first?.name ?? "")

        tblViewZoneWide.reloadData()
        tblViewAdditionalOppo.reloadData()
        tblViewExceptions.reloadData()
        collectionViewList.reloadData()
        
        updateSegmentSelection(selected: .zoneWide)
        
//        viewBottomPopup.isHidden = true
        popupHeightConstraint.constant = 110
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        viewBottomPopup.addGestureRecognizer(swipeDown)
        
        // New swipe up
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp))
        swipeUp.direction = .up
        viewBottomPopup.addGestureRecognizer(swipeUp)
        
        viewInnerBottomPopup.layer.applySketchShadow(
            color: .black,
            alpha: 0.3,
            x: 0,
            y: -3,
            blur: 10,
            spread: 1
        )
        
        if let firstFMZ = arrAllDataList.fmz.first {
            self.lblPopUpTitle.text = "General Information for FMZ \(firstFMZ.name ?? "")"
        }
                
        if let generalInfo = arrAllDataList.fishing_general_info.first {
            self.txtViewPopUP.text = generalInfo.info_resident ?? ""
        } else {
            self.txtViewPopUP.text = "No general information available."
        }
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

    @objc func handleSwipeUp() {
        showBottomPopup()
    }
    
    // Show Popup
    func showBottomPopup() {
        viewBottomPopup.isHidden = false
        self.view.layoutIfNeeded()
        
        let targetHeight = viewZoneWideMain.bounds.height
        
        UIView.animate(withDuration: 0.3) {
            self.popupHeightConstraint.constant = targetHeight
            self.view.layoutIfNeeded()
        }
        
        isPopupVisible = true
    }
    
    // Hide Popup
    func hideBottomPopup() {
        UIView.animate(withDuration: 0.3) {
            self.popupHeightConstraint.constant = 110
            self.view.layoutIfNeeded()
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
            viewBottomPopup.isHidden = false
        case .additional:
            lblAdditionalOppo.textColor = .black
            viewAdditionalBottomLine.backgroundColor = .primary
            viewZoneWideMain.isHidden = true
            viewAdditionalOppoMain.isHidden = false
            viewExceptionsMain.isHidden = true
            viewBottomPopup.isHidden = true
        case .exceptions:
            lblExceptions.textColor = .black
            viewExceptionsBottomLine.backgroundColor = .primary
            viewZoneWideMain.isHidden = true
            viewAdditionalOppoMain.isHidden = true
            viewExceptionsMain.isHidden = false
            viewBottomPopup.isHidden = true
        }
    }
    
    // MARK: - Compositional Layout
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(50))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(50))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            
            // Header – dynamic height using estimated
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(40) // Estimated height; will expand based on content
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
    }
    
}

extension FishingSeasonsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblViewAdditionalOppo {
            return arrFish.count
        }
//        else if tableView == tblViewExceptions {
//            return fishing_exception_types.count
//        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVIewList {
            return arrAllDataList.fmz.count
        } else if tableView == tblViewZoneWide {
            return arrAllFmzData.count
        } else if tableView == tblViewAdditionalOppo {
            if !expandedSectionsAdditionalOppo.contains(section) { return 0 }
            
            let dicData = arrFish[section]
            let additional = exceptions.filter { $0.fish_id == Double(dicData.id ?? Int(0.0)) }
            return additional.count > 0 ? additional.count : arrFish.count

        }
//        else if tableView == tblViewExceptions {
//            
//            if !expandedSections.contains(section) { return 0 }
//            
//            let dicData = fishing_exception_types[section]
//            let additional = exceptionsNew.filter { $0.exception_type_id == dicData.id && $0.fish_id == nil }
//            return additional.count > 0 ? additional.count : arrFish.count
//        }
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
            
//            let limits = dicData.limits_non_resident != "" ? "\(dicData.limits_resident ?? "") (Resident)" + (dicData.limits_non_resident ?? "") : dicData.limits_resident
            
            let season_resident = (dicData.limits_resident ?? "") + " " + "(Resident)"
            let season_non_resident = (dicData.limits_non_resident ?? "")
            let season = season_resident != "" ? season_resident + "\n" + season_non_resident : season_non_resident
            
            cell.viewLimitsMain.isHidden = season != "" ? false : true
            cell.lblLimit.text = season
            
            let fish_id = dicData.fish_id ?? 0
            
            if let fish = arrAllDataList.fish.first(where: { $0.id == fish_id }) {
                print("✅ Fish with id \(fish_id) exists, name = \(fish.name ?? "No name")")
                cell.lblFish.text = fish.name
            }
            
            if indexPath.item == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                cell.viewBottomLine.isHidden = true
            } else {
                cell.viewBottomLine.isHidden = false
            }
            
            return cell
        } else if tableView == tblViewAdditionalOppo {
            let cell = self.tblViewAdditionalOppo.dequeueReusableCell(withIdentifier: "AdditionalOppoTblViewCell") as! AdditionalOppoTblViewCell
                        
            let dicData = arrFish[indexPath.section]
            let additional = exceptions.filter { $0.fish_id == Double(dicData.id ?? Int(0.0)) }
            let dicDataEX =  additional[indexPath.row]
            
            cell.lblSeason.text = dicDataEX.season ?? ""
            cell.lblLimits.text = dicDataEX.limits ?? ""
            cell.lblDis.text = dicDataEX.description ?? ""
            
            cell.viewSeasonMain.isHidden = dicDataEX.season != "" ? false : true
            cell.viewLimitMain.isHidden = dicDataEX.limits != "" ? false : true
            cell.viewDescription.isHidden = dicDataEX.description != "" ? false : true
            
            
            if indexPath.item == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                cell.viewBottomLine.isHidden = true
            } else {
                cell.viewBottomLine.isHidden = false
            }
            
            return cell
        }
//        else if tableView == tblViewExceptions {
//            let cell = self.tblViewExceptions.dequeueReusableCell(withIdentifier: "ExceptionsDetailsTblViewCell") as! ExceptionsDetailsTblViewCell
//            
//            let dicData = fishing_exception_types[indexPath.section]
//            
//            let additional = exceptionsNew.filter { $0.exception_type_id == dicData.id && $0.fish_id == nil }
//
//            if additional.count > 0 {
//                let dicData = additional[indexPath.row]
//                
//                cell.lblExceptionDetailsTitle.text = dicData.title ?? ""
//
//                cell.viewSeason.isHidden = true
//                cell.viewLimit.isHidden = true
//                cell.viewDes.isHidden = false
//                
//                cell.lblDis.text = dicData.description ?? ""
//                
//                cell.viewAddi.isHidden = true
//                cell.imgLoca.isHidden = !cell.viewAddi.isHidden
//
//                cell.imgTOp.isHidden = true
//            } else {
//                let dicData = arrFish[indexPath.row]
//                let dicDataEX = exceptions[indexPath.row]
//
//                cell.imgTOp.isHidden = false
//                cell.lblExceptionDetailsTitle.text = dicData.name ?? ""
//                cell.imgTOp.tintColor = .primary
//                cell.imgTOp.image = UIImage(named: dicData.image_path ?? "")
//                
//                cell.lblSeason.text = dicDataEX.season ?? ""
//                cell.lblLimits.text = dicDataEX.limits ?? ""
//                cell.lblDis.text = dicDataEX.description ?? ""
//                
//                cell.viewSeason.isHidden = dicDataEX.season != "" ? false : true
//                cell.viewLimit.isHidden = dicDataEX.limits != "" ? false : true
//                cell.viewDes.isHidden = dicDataEX.description != "" ? false : true
//                
//                cell.viewAddi.isHidden = false
//                cell.imgLoca.isHidden = !cell.viewAddi.isHidden
//
//            }
//            
//            // Cell expand/collapse
//            let isExpanded = expandedCells[indexPath] ?? false
//            cell.viewBottomException.isHidden = !isExpanded
//            UIView.animate(withDuration: 0.25) {
//                cell.imgDropDown.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
//            }
//            
//            return cell
//        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVIewList {
            return 60
        } else if tableView == tblViewZoneWide {
            return UITableView.automaticDimension
        } else if tableView == tblViewAdditionalOppo {
            return UITableView.automaticDimension
        }
//        else if tableView == tblViewExceptions {
//            return UITableView.automaticDimension
//        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblVIewList {
            lblListName.text = "FMZ " + (arrAllDataList.fmz[indexPath.row].name ?? "")
            
            lblPopUpTitle.text = "General Information for FMZ \(arrAllDataList.fmz[indexPath.row].name ?? "")"
            
            txtViewPopUP.text = arrAllDataList.fishing_general_info[indexPath.row].info_resident ?? ""
            
            lblNoDataAddOppo.text = "no additional opportunities for FMZ " + (arrAllDataList.fmz[indexPath.row].name ?? "")
            lblNoDataExceptions.text = "no exceptions for FMZ " + (arrAllDataList.fmz[indexPath.row].name ?? "")
            
            let seasonIdToCheck = arrAllDataList.fmz[indexPath.row].id ?? 0
            fmz_id = seasonIdToCheck
            
            arrAllFmzData = arrAllDataList.fishing_seasons.filter { $0.fmz_id == seasonIdToCheck }
            
            let additional = arrAllDataList.exceptions.filter { $0.fmz_id == seasonIdToCheck && $0.fish_id != nil && $0.is_additional_opportunity == 1 }
            exceptions = additional
            
            let exceptionFishIds = additional.compactMap { $0.fish_id }
            arrFish = arrAllDataList.fish.filter { exceptionFishIds.contains(Double($0.id ?? 0)) }
            
            exceptionsNew = arrAllDataList.exceptions.filter { $0.fmz_id == seasonIdToCheck }
            
            exceptionIds.removeAll()
            let arrExten = arrAllDataList.exceptions.filter({ $0.fmz_id == fmz_id })
            for obj in arrExten {
                if !exceptionIds.contains(obj.exception_type_id ?? 0) {
                    exceptionIds.append(obj.exception_type_id ?? 0)
                }
            }
            fishing_exception_types = arrAllDataList.fishing_exception_types.filter { exceptionIds.contains($0.id ?? 0) }
            
            // ✅ Reset expanded states
            expandedSections.removeAll()
            expandedSectionsAdditionalOppo.removeAll()
            expandedCells.removeAll()
            expandedExceptionTypes.removeAll()
            expandedFish.removeAll()
            
            fishIds.removeAll()
            arrAllFishing.removeAll()
            
            lblNoDataExceptions.isHidden = fishing_exception_types.count > 0
            lblNoDataAddOppo.isHidden = arrFish.count > 0
            
            DispatchQueue.main.async {
                self.tblViewZoneWide.reloadData()
                self.tblViewAdditionalOppo.reloadData()
                self.tblViewExceptions.reloadData()
                self.collectionViewList.reloadData() // ✅ Reload collection view
            }
            
            isDropDownVisible = false
            UIView.animate(withDuration: 0.0) {
                self.viewMainList.isHidden = true
                self.imgDropDown.transform = .identity
            }
        }
//        else if tableView == tblViewExceptions {
//            print("Selected exceptions row: \(indexPath.row)")
//            
//            let isExpanded = expandedCells[indexPath] ?? false
//            expandedCells[indexPath] = !isExpanded
//            
//            tableView.beginUpdates()
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//            tableView.endUpdates()
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblViewAdditionalOppo {
            return UITableView.automaticDimension
        }
//        else if tableView == tblViewExceptions {
//            return UITableView.automaticDimension
//        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblViewAdditionalOppo {
            let headerView = Bundle.main.loadNibNamed("FishindHeaderView", owner: self, options: nil)?.first as! FishindHeaderView
            headerView.backgroundColor = .green
            
            headerView.tag = section
            
            // Add tap gesture
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTapAdd(_:)))
            headerView.addGestureRecognizer(tapGesture)
            
            // Configure header title
            let headerData = arrFish[section]
            headerView.lblName.text = headerData.name ?? "Exception Type"
            headerView.imgPic.image = UIImage(named: headerData.image_path ?? "")
            
            
            // Arrow rotation based on expansion
            if expandedSectionsAdditionalOppo.contains(section) {
                headerView.imgDrop.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
                headerView.imgDrop.transform = .identity
            }
            
            return headerView
        }
//        else if tableView == tblViewExceptions {
//            let headerView = Bundle.main.loadNibNamed("FishindHeaderView", owner: self, options: nil)?.first as! FishindHeaderView
//            headerView.backgroundColor = .green
//            
//            headerView.tag = section
//            
//            // Add tap gesture
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:)))
//            headerView.addGestureRecognizer(tapGesture)
//            
//            // Configure header title
//            let headerData = fishing_exception_types[section]
//            headerView.lblName.text = headerData.text ?? "Exception Type"
//            
//            headerView.imgPic.isHidden = true/*.image = UIImage(named: headerData.bubble_image ?? "")*/
//
//            
//            // Arrow rotation based on expansion
//            if expandedSections.contains(section) {
//                headerView.imgDrop.transform = CGAffineTransform(rotationAngle: .pi)
//            } else {
//                headerView.imgDrop.transform = .identity
//            }
//            
//            return headerView
//        }
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
    
    @objc func handleHeaderTapAdd(_ gesture: UITapGestureRecognizer) {
        guard let headerView = gesture.view else { return }
        let section = headerView.tag
        
        if expandedSectionsAdditionalOppo.contains(section) {
            expandedSectionsAdditionalOppo.remove(section)
        } else {
            expandedSectionsAdditionalOppo.insert(section)
        }
        
        tblViewAdditionalOppo.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

extension FishingSeasonsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fishing_exception_types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let fishing = fishing_exception_types[section].id ?? 0
        let filtered = AppDelegate.appDelegate.dicAllData.exceptions.filter { $0.exception_type_id == fishing && $0.fish_id == nil && $0.fmz_id == fmz_id }
        
        let filterFish = arrAllDataList.exceptions.filter({ $0.exception_type_id == fishing && $0.fmz_id == fmz_id })
        
        for obj in filterFish {
            if !fishIds.contains(obj.fish_id ?? 0) {
                fishIds.append(obj.fish_id ?? 0)
            }
        }
        
        let getFishData = arrAllDataList.fish.filter { fishIds.contains(Double($0.id ?? 0)) }
        arrAllFishing = getFishData
        
        guard expandedSections.contains(section) else { return 0 }
        
        var total = 0
        for (i, _) in filtered.enumerated() {
            total += 1
            let idx = IndexPath(item: i, section: section)
            if expandedExceptionTypes.contains(idx) {
                total += 1
            }
        }
        
        if total == 0 {
            var fishCount = 0
            for (i, _) in arrAllFishing.enumerated() {
                fishCount += 1
                let idx = IndexPath(item: i, section: section)
                if expandedFish.contains(idx) {
                    let fish = arrAllFishing[i]
                    let fishExceptions = AppDelegate.appDelegate.dicAllData.exceptions.filter {
                        $0.exception_type_id == fishing && $0.fish_id == Double(fish.id ?? 0) && $0.fmz_id == fmz_id
                    }
                    fishCount += fishExceptions.count
                }
            }
            return fishCount
        }
        
        return total
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let fishing = fishing_exception_types[indexPath.section].id ?? 0
//        let filtered = AppDelegate.appDelegate.dicAllData.exceptions.filter {
//            $0.exception_type_id == fishing && $0.fish_id == nil && $0.fmz_id == fmz_id
//        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let fishing = fishing_exception_types[indexPath.section].id ?? 0
        let filtered = AppDelegate.appDelegate.dicAllData.exceptions.filter {
            $0.exception_type_id == fishing && $0.fish_id == nil && $0.fmz_id == fmz_id
        }
        
        var rows: [(isDetail: Bool, title: String, imageName: String?)] = []
        
        if filtered.count > 0 {
            for (i, e) in filtered.enumerated() {
                // exceptions don't have an image in your models (as far as I can see),
                // so pass nil for imageName
                rows.append((false, e.title ?? "No Title", nil))
                let idx = IndexPath(item: i, section: indexPath.section)
                if expandedExceptionTypes.contains(idx) {
                    rows.append((true, e.description ?? "No description", nil))
                }
            }
        } else {
            // make sure fishIds doesn't grow forever (optional but recommended)
            fishIds.removeAll()
            for obj in arrAllDataList.exceptions.filter({ $0.exception_type_id == fishing && $0.fmz_id == fmz_id }) {
                if !fishIds.contains(obj.fish_id ?? 0) {
                    fishIds.append(obj.fish_id ?? 0)
                }
            }
            let getFishData = arrAllDataList.fish.filter { fishIds.contains(Double($0.id ?? 0)) }
            arrAllFishing = getFishData

            for (i, fish) in arrAllFishing.enumerated() {
                // use fish.image_path (if it exists) for the header row
                rows.append((false, fish.name ?? "Unknown Fish", fish.image_path))
                let idx = IndexPath(item: i, section: indexPath.section)
                if expandedFish.contains(idx) {
                    let fishExceptions = AppDelegate.appDelegate.dicAllData.exceptions.filter {
                        $0.exception_type_id == fishing && $0.fish_id == Double(fish.id ?? 0) && $0.fmz_id == fmz_id
                    }
                    for e in fishExceptions {
                        rows.append((true, e.description ?? "No description", nil))
                    }
                }
            }
        }
        
        let row = rows[indexPath.row]
        if row.isDetail {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExceptionsDetailsCVCell", for: indexPath) as! ExceptionsDetailsCVCell
            let filter = AppDelegate.appDelegate.dicAllData.exceptions
            
            for obj in filter {
                if row.title == obj.description {
                    cell.lblDis.text = obj.description ?? ""
                    cell.lblSeason.text = obj.season ?? ""
                    cell.lblLimits.text = obj.limits ?? ""
                    
                    cell.viewMainSeason.isHidden = (obj.season ?? "").isEmpty
                    cell.viewMainLimits.isHidden = (obj.limits ?? "").isEmpty
//                    cell.viewMainLimits.isHidden = obj.limits != "" ? false : true
                    cell.viewMainAdditionalOppo.isHidden = (obj.is_additional_opportunity ?? 0) != 1
                    
                    
                    break
                }
            }
            
            var lastDetailRowIndex = -1
            for (i, r) in rows.enumerated() {
                if r.isDetail { lastDetailRowIndex = i }
            }
            
            cell.viewBottomLine.isHidden = indexPath.row == lastDetailRowIndex
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListInnerHeaderCVCell", for: indexPath) as! ListInnerHeaderCVCell
            cell.lblTitle.text = row.title
            if let imageName = row.imageName, !imageName.isEmpty {
                cell.imgIcon.isHidden = false
                cell.imgIcon.image = UIImage(named: imageName)
                cell.imgIcon.tintColor = .primary
            } else {
                cell.imgIcon.isHidden = true
                cell.imgIcon.image = nil
            }
            
            var lastDetailRowIndex = 0
            for (i, r) in rows.enumerated() {
                if r.isDetail { lastDetailRowIndex = i }
            }
            
            cell.viewTopLine.isHidden = indexPath.row == lastDetailRowIndex
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: "HuterHeaderCVView",
                                                                     for: indexPath) as! HuterHeaderCVView
        header.tag = indexPath.section
        
        header.lblName.text = fishing_exception_types[indexPath.section].text ?? ""
        
        header.imgIcon.isHidden = true
        
        if expandedSections.contains(indexPath.section) {
            header.imgDropdown.transform = CGAffineTransform(rotationAngle: .pi)
        } else {
            header.imgDropdown.transform = .identity
        }
        
        header.tag = indexPath.section
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
        header.addGestureRecognizer(tapGesture)
        header.isUserInteractionEnabled = true
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fishing = fishing_exception_types[indexPath.section].id ?? 0
        let filtered = AppDelegate.appDelegate.dicAllData.exceptions.filter {
            $0.exception_type_id == fishing && $0.fish_id == nil && $0.fmz_id == fmz_id
        }
        
        if filtered.count > 0 {
            var rows: [(isDetail: Bool, index: Int)] = []
            for (i, _) in filtered.enumerated() {
                rows.append((false, i))
                let idx = IndexPath(item: i, section: indexPath.section)
                if expandedExceptionTypes.contains(idx) {
                    rows.append((true, i))
                }
            }
            
            let row = rows[indexPath.row]
            if !row.isDetail {
                let idx = IndexPath(item: row.index, section: indexPath.section)
                if expandedExceptionTypes.contains(idx) {
                    expandedExceptionTypes.remove(idx)
                } else {
                    expandedExceptionTypes.insert(idx)
                }
                collectionView.reloadSections(IndexSet(integer: indexPath.section))
            }
        } else {
            var rows: [(isDetail: Bool, index: Int)] = []
            for (i, _) in arrAllFishing.enumerated() {
                rows.append((false, i))
                let idx = IndexPath(item: i, section: indexPath.section)
                if expandedFish.contains(idx) {
                    let fish = arrAllFishing[i]
                    let fishExceptions = AppDelegate.appDelegate.dicAllData.exceptions.filter {
                        $0.exception_type_id == fishing && $0.fish_id == Double(fish.id ?? 0) && $0.fmz_id == fmz_id
                    }
                    for _ in fishExceptions {
                        rows.append((true, i))
                    }
                }
            }
            
            let row = rows[indexPath.row]
            if !row.isDetail {
                let idx = IndexPath(item: row.index, section: indexPath.section)
                if expandedFish.contains(idx) {
                    expandedFish.remove(idx)
                } else {
                    expandedFish.insert(idx)
                }
                collectionView.reloadSections(IndexSet(integer: indexPath.section))
            }
        }
    }
    
    @objc func headerTapped(_ sender: UITapGestureRecognizer) {
        guard let headerViewTapped = sender.view else { return }
        let section = headerViewTapped.tag
        // Toggle isExpanded
        // headerView[section].isExpanded.toggle()
        
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        
        // Reload section with animation
        collectionViewList.reloadSections(IndexSet(integer: section))
    }
    
    
}
