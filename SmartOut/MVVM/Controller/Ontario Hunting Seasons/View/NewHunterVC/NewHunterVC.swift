//
//  NewHunterVC.swift
//  SmartOut
//
//  Created by Ankit Gabani on 30/09/25.
//

import UIKit
import LGSideMenuController

class NewHunterVC: UIViewController {
    
    @IBOutlet weak var lblDropDown: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    
    @IBOutlet weak var viewMainList: UIView!
    @IBOutlet weak var tblViewListMain: UITableView! {
        didSet {
            
            tblViewListMain.sectionHeaderTopPadding = 0
            tblViewListMain.register(UINib(nibName: "DropDownTblViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTblViewCell")
            tblViewListMain.delegate = self
            tblViewListMain.dataSource = self
        }
    }
    
    @IBOutlet weak var collectionViewList: UICollectionView! {
        didSet {
            collectionViewList.collectionViewLayout = createCompositionalLayout()
            
            collectionViewList.delegate = self
            collectionViewList.dataSource = self
            
            collectionViewList.register(UINib(nibName: "ListDetailsCVCell", bundle: nil), forCellWithReuseIdentifier: "ListDetailsCVCell")
            
            collectionViewList.register(UINib(nibName: "ListInnerHeaderCVCell", bundle: nil), forCellWithReuseIdentifier: "ListInnerHeaderCVCell")
            
            collectionViewList.register(UINib(nibName: "HuterHeaderCVView", bundle: nil),
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: "HuterHeaderCVView")
        }
    }
    
    @IBOutlet weak var tblViewList: UITableView!
    
    
    var arrAllDataList = AppDelegate.appDelegate.dicAllData
    var filteredWMUs: [WMU] = []
    var expandedSections: Set<Int> = []
    var expandedSectionsTV: Set<Int> = []
    var expandedSeasonTypes: Set<IndexPath> = []
    var selectedwmuID = "1"
    
    var arrHuntingSeasons: [HuntingSeason] = []
    var arrAnimal: [Animal] = []
    var arrSeasonId = NSMutableArray()
    
    var isDropDownVisible = false
    
    var expandedIndexSet: Set<Int> = []
    var expandedIndexDocument: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblViewList.sectionFooterHeight = 0
        tblViewList.sectionHeaderTopPadding = 8
        tblViewList.register(UINib(nibName: "ListDetailsTblViewCell", bundle: nil), forCellReuseIdentifier: "ListDetailsTblViewCell")
        tblViewList.dataSource = self
        tblViewList.delegate = self
        
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
        
        
        lblDropDown.text = "All WMUs"
        selectedwmuID = ""
        
        tblViewList.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        if let sideMenu = self.sideMenuController?.leftViewController as? SideMenuVC {
            sideMenu.updateSelectedMenu(index: 2)
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
    
    @IBAction func btnMenuAction(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true, completion: nil)
    }
    
    @IBAction func btnTapDropDownAction(_ sender: Any) {
        viewMainList.isHidden.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.imgDropDown.transform = self.viewMainList.isHidden ? .identity : CGAffineTransform(rotationAngle: .pi)
        }
    }
    
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

// MARK: - TV Delegate & DataSource
extension NewHunterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblViewList {
            return arrAnimal.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewListMain {
            return filteredWMUs.count
        } else if tableView == tblViewList {
            if expandedSectionsTV.contains(section) {
                let animalId = arrAnimal[section].id ?? 0
                return arrHuntingSeasons.filter { $0.animal_id == animalId }.count
            } else {
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblViewListMain {
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
            
            cell.viewTop.isHidden = true
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblViewListMain {
            return 50
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
            
            if expandedSectionsTV.contains(section) {
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
        if expandedSectionsTV.contains(section) {
            expandedSectionsTV.remove(section)
        } else {
            expandedSectionsTV.insert(section)
        }
        tblViewList.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblViewListMain {
            let selectedWMU = filteredWMUs[indexPath.row]
            if selectedWMU.id == 1 {
                lblDropDown.text = "All WMUs"
                selectedwmuID = ""
                loadAllSeasons()
                
                tblViewList.isHidden = true
                collectionViewList.isHidden = false
                
            } else {
                lblDropDown.text = "WMU " + (selectedWMU.name ?? "")
                selectedwmuID = selectedWMU.name ?? ""
                loadSeasons(forWMU: selectedWMU.id ?? 0)
                
                tblViewList.isHidden = false
                collectionViewList.isHidden = true
            }
            
            tblViewList.reloadData()
            isDropDownVisible = false
            UIView.animate(withDuration: 0.2) {
                self.viewMainList.isHidden = true
                self.imgDropDown.transform = .identity
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
    
    
}

// MARK: - CV Delegate & DataSource
extension NewHunterVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return AppDelegate.appDelegate.dicAllData.animals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let arrAnimal = AppDelegate.appDelegate.dicAllData.animals
        let animalId = arrAnimal[section].id ?? 0
        let arrHunter = AppDelegate.appDelegate.dicAllData.hunting_seasons.filter { $0.animal_id == animalId }
        let groupedSeasons = Dictionary(grouping: arrHunter, by: { $0.season_type ?? "" })
        let sectionTitles = groupedSeasons.keys.sorted()
        guard expandedSections.contains(section) else { return 0 }
        var total = 0
        for (i, type) in sectionTitles.enumerated() {
            total += 1
            let idx = IndexPath(item: i, section: section)
            if expandedSeasonTypes.contains(idx) {
                total += groupedSeasons[type]?.count ?? 0
            }
        }
        return total
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let arrAnimal = AppDelegate.appDelegate.dicAllData.animals
        let animalId = arrAnimal[indexPath.section].id ?? 0
        let arrHunter = AppDelegate.appDelegate.dicAllData.hunting_seasons.filter { $0.animal_id == animalId }
        let groupedSeasons = Dictionary(grouping: arrHunter, by: { $0.season_type ?? "" })
        let sectionTitles = groupedSeasons.keys.sorted()
        
        // Build row list with type
        var rows: [(isType: Bool, type: String?, season: HuntingSeason?)] = []
        for (i, type) in sectionTitles.enumerated() {
            rows.append((true, type, nil))
            let idx = IndexPath(item: i, section: indexPath.section)
            if expandedSeasonTypes.contains(idx) {
                for s in groupedSeasons[type] ?? [] {
                    rows.append((false, nil, s))
                }
            }
        }
        
        let row = rows[indexPath.row]
        if row.isType {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ListInnerHeaderCVCell",
                for: indexPath
            ) as! ListInnerHeaderCVCell
            cell.lblTitle.text = row.type
            
            if expandedSeasonTypes.contains(indexPath) {
                cell.imgDrop.transform = CGAffineTransform(rotationAngle: .pi) // rotated down
            } else {
                cell.imgDrop.transform = .identity // default up
            }
            
            cell.imgIcon.isHidden = true
            
            return cell
        } else if let season = row.season {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ListDetailsCVCell",
                for: indexPath
            ) as! ListDetailsCVCell
            
            
//            let season_resident = (season.season_resident ?? "") + " " + "(Resident)"
//            let season_non_resident = (season.season_non_resident ?? "") + " " + "(Non-resident)"
//            let season2 = season_resident != "" ? season_resident + "\n" + season_non_resident : season_non_resident
//            cell.lblSeason.text = season2
            
            let residentText = season.season_resident?.isEmpty == false ? (season.season_resident! + " (Resident)") : nil
            let nonResidentText = season.season_non_resident?.isEmpty == false ? (season.season_non_resident! + " (Non-resident)") : nil
            let season2 = [residentText, nonResidentText].compactMap { $0 }.joined(separator: "\n")

            cell.lblSeason.text = season2
            
            cell.lblWMUs.text = season.short_wmu_list ?? ""
            cell.lblConditions.text = season.conditions_text ?? ""
            
            cell.viewMainRifle.isHidden = season.rifles_allowed != 1
            cell.viewMainShotgun.isHidden = season.shotguns_allowed != 1
            cell.viewMainMuzzleloader.isHidden = season.muzzleloaders_allowed != 1
            cell.viewMainBow.isHidden = season.bows_allowed != 1
            
            cell.lblConditions.text = season.conditions_text
            cell.viewMainConditions.isHidden = (season.conditions_text ?? "").isEmpty
            cell.viewMainWMUs.isHidden = (season.short_wmu_list ?? "").isEmpty
            cell.viewMainSeason.isHidden = (season.season_resident ?? "").isEmpty && (season.season_non_resident ?? "").isEmpty
            
            let rowsInSection = rows.filter { !$0.isType }   // only details for this section
            if let lastSeason = rowsInSection.last?.season {
                cell.viewBottomLine.isHidden = (season.id == lastSeason.id)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: "HuterHeaderCVView",
                                                                     for: indexPath) as! HuterHeaderCVView
        header.tag = indexPath.section
        
        header.lblName.text = AppDelegate.appDelegate.dicAllData.animals[indexPath.section].name ?? ""
        
        if let imageName = AppDelegate.appDelegate.dicAllData.animals[indexPath.section].image_path {
            header.imgIcon.image = UIImage(named: imageName)
        } else {
            header.imgIcon.image = nil
        }
        
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
        let arrAnimal = AppDelegate.appDelegate.dicAllData.animals
        let animalId = arrAnimal[indexPath.section].id ?? 0
        let arrHunter = AppDelegate.appDelegate.dicAllData.hunting_seasons.filter { $0.animal_id == animalId }
        let groupedSeasons = Dictionary(grouping: arrHunter, by: { $0.season_type ?? "" })
        let sectionTitles = groupedSeasons.keys.sorted()
        
        var counter = 0
        for (i, type) in sectionTitles.enumerated() {
            if indexPath.row == counter {
                let idx = IndexPath(item: i, section: indexPath.section)
                if expandedSeasonTypes.contains(idx) {
                    expandedSeasonTypes.remove(idx)
                } else {
                    expandedSeasonTypes.insert(idx)
                }
                collectionView.reloadSections(IndexSet(integer: indexPath.section))
                return
            }
            counter += 1
            if expandedSeasonTypes.contains(IndexPath(item: i, section: indexPath.section)) {
                counter += groupedSeasons[type]?.count ?? 0
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
