//
//  HunterReportingTblViewCell.swift
//  SmartOut
//
//  Created by iMac on 15/09/25.
//

import UIKit
import Charts
import DGCharts


protocol reloadCell: AnyObject {
    func reloadData()
}

class HunterReportingTblViewCell: UITableViewCell {

    @IBOutlet weak var imgAnimal: UIImageView! {
        didSet {
            imgAnimal.tintColor = .primary
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSpringChart: UIView!
    @IBOutlet weak var viewFallChart: UIView!
    @IBOutlet weak var view3ValueChart: UIView!
    
    @IBOutlet weak var lblFChartName: UILabel!
    @IBOutlet weak var lblSChartName: UILabel!
    
    @IBOutlet weak var collectionViewDataTable: UICollectionView!
    
    @IBOutlet weak var viewMainChart: UIView!
    @IBOutlet weak var viewMainCharS: UIView!
    
    
    @IBOutlet weak var lblBull: UILabel!
    @IBOutlet weak var lblCow: UILabel!
    @IBOutlet weak var lblCalf: UILabel!
    
    @IBOutlet weak var lblBullValue: UILabel!
    @IBOutlet weak var lblCowValue: UILabel!
    @IBOutlet weak var lblCalfValue: UILabel!
    
    @IBOutlet weak var viewClaf: UIView!
    @IBOutlet weak var viewCalfMain: UIView!
    
    @IBOutlet weak var viewCalfColor: UIView!
    
    @IBOutlet weak var lblFColor: UILabel!
    @IBOutlet weak var lblSColor: UILabel!
    @IBOutlet weak var lblTColor: UILabel!
    
    @IBOutlet weak var heightCV: NSLayoutConstraint!
    
    let SlidarsectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    let SlidaritemsPerRow : CGFloat = 1
    var SlidarflowLayout: UICollectionViewFlowLayout {
        let _SlidarflowLayout = UICollectionViewFlowLayout()
        
        DispatchQueue.main.async {
            let paddingSpace = self.SlidarsectionInsets.left * (self.SlidaritemsPerRow + 1)
            let availableWidth = self.collectionViewDataTable.frame.width - paddingSpace
            let widthPerItem = availableWidth / self.SlidaritemsPerRow
            
            _SlidarflowLayout.itemSize = CGSize(width: widthPerItem, height: 25)
            
            _SlidarflowLayout.sectionInset = self.SlidarsectionInsets
            _SlidarflowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
            _SlidarflowLayout.minimumInteritemSpacing = 0
            _SlidarflowLayout.minimumLineSpacing = 0
        }
        
        // edit properties here
        return _SlidarflowLayout
    }
    
    var delegateReload: reloadCell?
    
    var arrAllRpe: [[String: Any]] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionViewDataTable.reloadData()
                self.collectionViewDataTable.layoutIfNeeded()
                
                let newHeight = self.collectionViewDataTable.collectionViewLayout.collectionViewContentSize.height
                self.heightCV.constant = newHeight
                
                self.setNeedsLayout()
                self.layoutIfNeeded()
                
                self.delegateReload?.reloadData()
                
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewDataTable.register(UINib(nibName: "DataTableCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DataTableCollectionViewCell")
        collectionViewDataTable.delegate = self
        collectionViewDataTable.dataSource = self
        collectionViewDataTable.collectionViewLayout =  SlidarflowLayout
        
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.heightCV.constant = self.collectionViewDataTable.collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension HunterReportingTblViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAllRpe.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewDataTable.dequeueReusableCell(withReuseIdentifier: "DataTableCollectionViewCell", for: indexPath) as! DataTableCollectionViewCell
        
        let dicData = arrAllRpe[indexPath.item]
        
        let metric_name = dicData["metric_name"] as? String ?? ""
        cell.lblTitle.text = metric_name
        
        
        if let value = dicData["value"] as? [[String: Any]] {
            for val in value {
                let year = val["year"] as? String ?? ""
                let percent = val["metric_in_percent"] as? String ?? ""
                print("   Year:", year, "Value:", percent)
                
                if year == "2021" {
                    cell.lblValue1.text = percent
                }
                
                if year == "2022" {
                    cell.lblValue2.text = percent
                }
                
                if year == "2023" {
                    cell.lblValue3.text = percent
                }
                
                if year == "2024" {
                    cell.lblValue4.text = percent
                }
            }
        }
        
        
        if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            cell.viewBottomLine.isHidden = true
        } else {
            cell.viewBottomLine.isHidden = false
        }
        
        return cell
    }
    
    
}
