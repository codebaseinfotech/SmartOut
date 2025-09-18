//
//  HunterReportingTblViewCell.swift
//  SmartOut
//
//  Created by iMac on 15/09/25.
//

import UIKit
import Charts
import DGCharts




class HunterReportingTblViewCell: UITableViewCell {

    @IBOutlet weak var imgAnimal: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSpringChart: UIView!
    @IBOutlet weak var viewFallChart: UIView!
    @IBOutlet weak var view3ValueChart: UIView!
    
    @IBOutlet weak var lblFChartName: UILabel!
    @IBOutlet weak var lblSChartName: UILabel!
    
    @IBOutlet weak var collectionViewDataTable: UICollectionView!
    
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
    
    var arrListName: [MetricGroup] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewDataTable.register(UINib(nibName: "DataTableCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DataTableCollectionViewCell")
        collectionViewDataTable.delegate = self
        collectionViewDataTable.dataSource = self
        collectionViewDataTable.collectionViewLayout =  SlidarflowLayout
      
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension HunterReportingTblViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrListName.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewDataTable.dequeueReusableCell(withReuseIdentifier: "DataTableCollectionViewCell", for: indexPath) as! DataTableCollectionViewCell
        
        if indexPath.row == 0 {
            cell.lblTitle.isHidden = true
            cell.lblValue1.text = "2021"
            cell.lblValue2.text = "2022"
            cell.lblValue3.text = "2023"
            cell.lblValue4.text = "2024"
        }
        
//        let dicData = statsDict[0][indexPath.item]
        
        if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            cell.viewBottomLine.isHidden = true
        } else {
            cell.viewBottomLine.isHidden = false
        }
        
        return cell
    }
    
    
}
