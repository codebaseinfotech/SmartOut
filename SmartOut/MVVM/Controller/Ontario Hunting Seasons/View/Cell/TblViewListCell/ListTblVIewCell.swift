//
//  ListTblVIewCell.swift
//  SmartOut
//
//  Created by iMac on 16/09/25.
//

import UIKit

class ListTblVIewCell: UITableViewCell {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottomDetails: UIView!
    
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    
    @IBOutlet weak var tblViewListDetails: UITableView!
    
    @IBOutlet weak var bottomDetailsHeightConstraint: NSLayoutConstraint!
    
    var arrHuntingSeasons: [HuntingSeason] = []

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tblViewListDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblViewListDetails.isScrollEnabled = false
        
        tblViewListDetails.register(UINib(nibName: "ListDetailsTblViewCell", bundle: nil), forCellReuseIdentifier: "ListDetailsTblViewCell")
        tblViewListDetails.dataSource = self
        tblViewListDetails.delegate = self
        
        viewBottomDetails.isHidden = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            DispatchQueue.main.async { [self] in
                bottomDetailsHeightConstraint.constant = tblViewListDetails.contentSize.height
                if let tableView = self.superview as? UITableView {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
            
        }
    }
    
    deinit {
        tblViewListDetails.removeObserver(self, forKeyPath: "contentSize")
    }

}

extension ListTblVIewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHuntingSeasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewListDetails.dequeueReusableCell(withIdentifier: "ListDetailsTblViewCell") as! ListDetailsTblViewCell
        
        let dicData = arrHuntingSeasons[indexPath.row]
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}
