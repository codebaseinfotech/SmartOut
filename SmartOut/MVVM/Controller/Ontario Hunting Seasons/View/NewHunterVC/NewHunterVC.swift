//
//  NewHunterVC.swift
//  SmartOut
//
//  Created by Ankit Gabani on 30/09/25.
//

import UIKit

class NewHunterVC: UIViewController {
    
    @IBOutlet weak var lblDropDown: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    
    @IBOutlet weak var viewMainList: UIView!
    @IBOutlet weak var tblViewListMain: UITableView! {
        didSet {
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
    
    var arrAllDataList = AppDelegate.appDelegate.dicAllData
    var filteredWMUs: [WMU] = []
    var expandedSections: Set<Int> = []
    var expandedSeasonTypes: Set<IndexPath> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ✅ Build filtered WMU list
        let seasonWMUIds = Set(arrAllDataList.hunting_season_wmus.map { $0.wmu_id ?? 0 })
        filteredWMUs = arrAllDataList.wmu.filter { wmu in
            if let id = wmu.id {
                return seasonWMUIds.contains(id)
            }
            return false
        }
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Compositional Layout
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(50))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
            
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
    }
    
    @IBAction func btnTapDropDownAction(_ sender: Any) {
    }
    
    
}

// MARK: - TV Delegate & DataSource
extension NewHunterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredWMUs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTblViewCell", for: indexPath) as! DropDownTblViewCell
        
        let wmu = filteredWMUs[indexPath.row]
        if wmu.name == "1" {
            cell.lblDropDownName.text = "All WMUs"
        } else {
            cell.lblDropDownName.text = "WMU " + (wmu.name ?? "")
        }
        
        return cell
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
        var rows: [(isType: Bool, text: String)] = []
        for (i, type) in sectionTitles.enumerated() {
            rows.append((true, type))
            let idx = IndexPath(item: i, section: indexPath.section)
            if expandedSeasonTypes.contains(idx) {
                for s in groupedSeasons[type] ?? [] {
                    rows.append((false, s.season_resident ?? ""))
                }
            }
        }
        
        let row = rows[indexPath.row]
        if row.isType {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListInnerHeaderCVCell", for: indexPath) as! ListInnerHeaderCVCell
            cell.lblTitle.text = row.text
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListDetailsCVCell", for: indexPath) as! ListDetailsCVCell
            cell.lblSeason.text = row.text
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: "HuterHeaderCVView",
                                                                     for: indexPath) as! HuterHeaderCVView
        header.backgroundColor = .systemBlue
        header.tag = indexPath.section
        
        header.lblName.text = AppDelegate.appDelegate.dicAllData.animals[indexPath.section].name ?? ""
        
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
